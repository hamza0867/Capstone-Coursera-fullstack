# frozen_string_literal: true

require 'rails_helper'

describe 'States', type: :request do
  describe 'GET /states' do
    it 'works! (now write some real specs)' do
      get states_path, xhr: true
      expect(response).to have_http_status(200)
    end
  end
end
