# frozen_string_literal: true

require 'rails_helper'

describe 'ApiDevelopments', type: :request do
  def parsed_body
    JSON.parse(response.body)
  end

  describe 'RDBMS-backed' do
    include_context 'db_cleanup', :transaction

    before :all do
      @foo = FactoryGirl.create(:foo, name: 'test')
    end

    subject { @foo }

    it 'create RDBMS-backed model' do
      expect(Foo.find(@foo.id).name).to eq('test')
    end

    it 'expose RDBMS-backed API resource' do
      expect(foos_path).to eq('/api/foos')
      get foo_path(@foo.id)
      expect(response).to have_http_status(:ok)
      expect(parsed_body['name']).to eq('test')
    end
  end

  describe 'MongoDB-backed' do
    include_context 'db_cleanup'

    before :all do
      @bar = FactoryGirl.create(:bar_faker, name: 'test')
    end
    it 'create MongoDB-backed model' do
      expect(Bar.find(@bar.id).name).to eq('test')
    end
    it 'expose MongoDB-backed API resource' do
      expect(bars_path).to eq('/api/bars')
      get bar_path(@bar.id)
      expect(response).to have_http_status(:ok)
      expect(parsed_body['name']).to eq('test')
      expect(parsed_body).to include('created_at')
      expect(parsed_body).to include('id' => @bar.id.to_s)
    end
  end
end
