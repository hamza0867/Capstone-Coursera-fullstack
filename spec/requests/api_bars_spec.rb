# frozen_string_literal: true

require 'rails_helper'

describe 'Bar API', type: :request do
  include_context 'db_cleanup_each', :transaction

  context 'caller requests list of Bars' do
    it_should_behave_like 'resource index', :bar
  end

  context 'a specific Bar exists' do
    it_should_behave_like 'show resource', :bar do
      let(:response_check) do
        expect(payload).to have_key('id')
        expect(payload).to have_key('name')
        # we added .to_s because we need to compare raw id strings
        # and not BSON::ObjectId
        expect(payload['id']).to eq(resource.id.to_s)
        expect(payload['name']).to eq(resource.name)
      end
    end
  end

  context 'create a new Bar' do
    it_should_behave_like 'create resource', :bar
  end

  context 'existing Bar' do
    it_should_behave_like 'modifiable resource', :bar do
      let(:update_check) do
        # verify name is not yet the new name
        expect(resource['name']).to_not eq(new_state[:name])
        # verify DB has instance updated with name
        expect(Bar.find(resource['id']).name).to eq(new_state[:name])
      end
    end
  end
end
