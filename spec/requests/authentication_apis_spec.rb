# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authentication Api', type: :request do
  include_context 'db_cleanup_each', :transaction
  let(:user_props) { FactoryGirl.attributes_for(:user) }

  context 'signup' do
    context 'valid registration' do
      it 'successfully creates an account' do
        signup user_props

        payload = parsed_body
        expect(payload).to include('status' => 'success')
        expect(payload).to include('data')
        expect(payload['data']).to include('id')
        expect(payload['data']).to include('provider' => 'email')
        expect(payload['data']).to include('uid' => user_props[:email])
        expect(payload['data']).to include('name' => user_props[:name])
        expect(payload['data']).to include('email' => user_props[:email])
        expect(payload['data']).to include('created_at', 'updated_at')
      end
    end

    context 'invalid registration' do
      context 'missing information' do
        it 'reports error with messages' do
          signup user_props.except(:email), :unprocessable_entity

          payload = parsed_body
          expect(payload).to include('status' => 'error')
          expect(payload).to include('data')
          expect(payload['data']).to include('email' => nil)
          expect(payload).to include('errors')
          expect(payload['errors']).to include('email')
          expect(payload['errors']).to include('full_messages')
          expect(payload['errors']['full_messages']).to include(/Email/i)
        end
      end
      context 'non unique information' do
        it 'reports non unique email' do
          signup user_props
          signup user_props, :unprocessable_entity

          payload = parsed_body

          expect(payload).to include('data')
          expect(payload['data']).to include('email' => user_props[:email])
          expect(payload).to include('errors')
          expect(payload['errors']).to include('email')
          expect(payload['errors']).to include('full_messages')
          expect(payload['errors']['full_messages']).to include(/Email/i)
        end
      end
    end
  end

  context 'anonymous user' do
    it 'accesses unprotected' do
      get authn_whoami_path
      expect(response).to have_http_status(:ok)

      expect(parsed_body).to eq({})
    end
    it 'fails to access protected resource' do
      get authn_checkme_path
      expect(response).to have_http_status(:unauthorized)

      expect(parsed_body).to include('errors' =>
                                     ['You need to sign in or sign up before continuing.'])
    end
  end

  context 'login' do
    let(:account) { signup user_props }
    let!(:user) { login account }

    context 'valid user login' do
      it 'generates access token' do
        expect(response.headers['uid']).to eq(account[:uid])
        expect(response.headers).to include('access-token')
        expect(response.headers).to include('client')
        expect(response.headers['token-type']).to eq('Bearer')
      end

      it 'extracts access headers' do
        expect(access_tokens?).to be true
        expect(access_tokens['uid']).to eq(account[:uid])
        expect(access_tokens).to include('access-token')
        expect(access_tokens).to include('client')
        expect(access_tokens['token-type']).to eq('Bearer')
      end

      it 'grants access to resource' do
        get authn_checkme_path, headers: access_tokens
        expect(response).to have_http_status(:ok)

        payload = parsed_body
        expect(payload['id']).to eq(account[:id])
        expect(payload['uid']).to eq(account[:uid])
      end

      it 'grants access to resource multiple times' do
        10.times do
          get authn_checkme_path, headers: access_tokens
          expect(response).to have_http_status(:ok)
        end
      end

      it 'logout' do
        logout
        expect(access_tokens?).to be_falsey
        get authn_checkme_path, headers: access_tokens
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'invalid password' do
      it 'rejects credentials' do
        login account.merge(password: 'badpassword'), :unauthorized
      end
    end
  end
end
