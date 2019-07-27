# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Things', type: :request do
  include_context 'db_cleanup_each'
  let(:account) { signup FactoryGirl.attributes_for(:user) }

  context 'quick API check' do
    let!(:user) { login account }
    it_should_behave_like 'resource index', :thing
    it_should_behave_like 'show resource', :thing
    it_should_behave_like 'create resource', :thing
    it_should_behave_like 'modifiable resource', :thing
  end

  shared_examples 'cannot create' do
    let!(:user) { login account }
    it 'reports for invalid data' do
      jpost things_path, params: thing_props.except(:name)
      expect(response).to have_http_status(:bad_request)
      payload = parsed_body
      expect(payload).to include('errors')
      expect(payload['errors']).to include('full_messages')
      expect(payload['errors']['full_messages']).to include('param is missing or the value is empty: name')
    end

    it 'create fails' do
      jpost things_path, params: things_props
      expect(response.status).to be >= 400
      expect(response.status).to be < 500
      expect(parsed_body).to include('errors')
    end
  end

  shared_examples 'can create' do
    it 'is created' do
      jpost things_path, params: thing_props
      # pp parsed_body
      expect(response).to have_http_status(:created)
      payload = parsed_body
      expect(payload).to include('id')
    end
  end

  shared_examples 'all fields present' do
    it 'list has all fields' do
      login account
      jget things_path
      expect(response).to have_http_status(:ok)
      payload = parsed_body
      expect(payload.size).to_not eq(0)
      payload.each do |r|
        expect(r).to include('id')
      end
    end

    it 'get has all fields ' do
      jget thing_path(thing_id)
      expect(response).to have_http_status(:ok)
      # pp parsed_body
      payload = parsed_body
      expect(payload).to include('id' => thing.id)
    end
  end
  describe 'access' do
    let(:things_props) { 3.times.map { FactoryGirl.attributes_for(:thing) } }
    let(:thing_props) { things_props[0] }
    let!(:things) { Thing.create(things_props) }
    let(:thing_id)  { things[0]['id'] }
    let(:thing)     { Thing.find(thing_id) }

    context 'unauthenticated user' do
      before(:each) { logout nil }
      it_should_behave_like 'cannot create'
      it_should_behave_like 'all fields present'
    end

    context 'authentiated user' do
      let!(:user) { login account }
      it_should_behave_like 'all fields present'
      it_should_behave_like 'can create'
    end
  end
end
