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
end
