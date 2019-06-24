# frozen_string_literal: true

require 'rails_helper'

describe 'Foo API', type: :request do
  include_context 'db_cleanup_each', :transaction

  context 'caller requests list of Foos' do
    it_should_behave_like 'resource index', :foo
  end

  context 'a specific Foo exists' do
    it_should_behave_like 'show resource', :foo do
      let(:response_check) do
        expect(payload).to have_key('id')
        expect(payload).to have_key('name')
        expect(payload['id']).to eq(resource.id)
        expect(payload['name']).to eq(resource.name)
      end
    end
  end

  context 'create a new Foo' do
    it_should_behave_like 'create resource', :foo
  end

  context 'existing Foo' do
    it_should_behave_like 'modifiable resource', :foo do
      let(:update_check) do
        # verify name is not yet the new name
        expect(resource['name']).to_not eq(new_state[:name])
        # verify DB has instance updated with name
        expect(Foo.find(resource['id']).name).to eq(new_state[:name])
      end
    end
  end
end
