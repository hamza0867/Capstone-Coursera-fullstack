# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Thing, type: :model do
  include_context 'db_cleanup'

  context 'build valid thing' do
    it 'default thing created with random non-nil description' do
      thing = FactoryGirl.build(:thing)
      expect(thing.description).to_not be_nil
      expect(thing.save).to be true
    end

    it 'thing with explicit nil description' do
      thing = FactoryGirl.build(:thing, description: nil)
      expect(thing.description).to be_nil
      expect(thing.save).to be true
    end
  end
end
