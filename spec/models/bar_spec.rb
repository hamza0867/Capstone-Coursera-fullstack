# frozen_string_literal: true

require 'rails_helper'
require 'mongo'

describe Bar, type: :model do
  include_context 'db_cleanup'

  before :all do
    @bar = Bar.create(name: 'test')
  end

  context 'created Bar' do
    subject { @bar }

    it { is_expected.to be_persisted }
    it { expect(subject.name).to eq('test')  }
    it { expect(Bar.find(subject.id)).to_not be_nil }
  end
end
