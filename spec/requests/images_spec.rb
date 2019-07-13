# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Images', type: :request do
  include_context 'db_cleanup_each'
  let(:account) { signup FactoryGirl.attributes_for(:user) }

  context 'quick API check' do
    let!(:user) { login account }
    it_should_behave_like 'resource index', :image
    it_should_behave_like 'show resource', :image
    it_should_behave_like 'create resource', :image
    it_should_behave_like 'modifiable resource', :image
  end

  shared_examples 'cannot create' do
    it 'create fails' do
      jpost images_path, params: image_props
      expect(response.status).to be >= 400
      expect(response.status).to be < 500
      expect(parsed_body).to include('errors')
    end
  end

  shared_examples 'cannot update' do |status|
    it "update fails with #{status}" do
      jput image_path(image_id), FactoryGirl.attributes_for(:image)
      expect(response).to have_http_status(status)
      expect(parsed_body).to include('errors')
    end
  end

  shared_examples 'cannot delete' do |status|
    it "delete fails with #{status}" do
      jdelete image_path(image_id), image_props
      expect(response).to have_http_status(status)
      expect(parsed_body).to include('errors')
    end
  end

  shared_examples 'can create' do
    it 'is created' do
      jpost images_path, params: image_props
      # pp parsed_body
      expect(response).to have_http_status(:created)
      payload = parsed_body
      expect(payload).to include('id')
      expect(payload['caption']).to eq(image_props[:caption])
    end
  end

  shared_examples 'can update' do
    it 'can update' do
      jput image_path(image_id), image_props
      expect(response).to have_http_status(:no_content)
    end
  end

  shared_examples 'can delete' do
    it 'can delete' do
      jdelete image_path(image_id)
      expect(response).to have_http_status(:no_content)
    end
  end

  shared_examples 'all fields present' do
    it 'list has all fields' do
      jget images_path
      expect(response).to have_http_status(:ok)
      payload = parsed_body
      expect(payload.size).to_not eq(0)
      payload.each do |r|
        expect(r).to include('id')
        expect(r).to include('caption')
      end
    end

    it 'get has all fields ' do
      jget image_path(image_id)
      expect(response).to have_http_status(:ok)
      # pp parsed_body
      payload = parsed_body
      expect(payload).to include('id' => image.id)
      expect(payload).to include('caption' => image.caption)
    end
  end

  describe 'access' do
    let(:images_props) { 3.times.map { FactoryGirl.attributes_for(:image, :with_caption) } }
    let(:image_props) { images_props[0] }
    let!(:images) { Image.create(images_props) }
    let(:image_id)  { images[0]['id'] }
    let(:image)     { Image.find(image_id) }

    context 'caller is unauthenticated' do
      before(:each) { logout nil }
      it_should_behave_like 'cannot create'
      it_should_behave_like 'all fields present'
    end

    context 'authenticated caller' do
      let!(:user) { login account }
      it_should_behave_like 'can create'
      it_should_behave_like 'all fields present'
    end
  end
end
