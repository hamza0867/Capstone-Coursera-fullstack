# frozen_string_literal: true

require 'rails_helper'

describe 'Cities', type: :request do
  describe 'GET /cities' do
    it 'works! (now write some real specs)' do
      get cities_path
      expect(response).to have_http_status(200)
    end
  end
end
