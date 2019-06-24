# frozen_string_literal: true

require 'rails_helper'

describe Foo, type: :model do
  include_context 'db_cleanup', :transaction
  before :all do
    @foo = Foo.create(name: 'test')
  end

  context 'created Foo' do
    subject { @foo }

    it { is_expected.to be_persisted }
    it { expect(subject.name).to eq('test') }
    it { expect(Foo.find(subject.id)).to_not be_nil }
  end
end
