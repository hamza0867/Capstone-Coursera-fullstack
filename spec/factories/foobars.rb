# frozen_string_literal: true

FactoryGirl.define do
  factory :foo_named_test, class: 'Foo' do
    name { 'test' }
  end

  factory :foo_faker, class: 'Foo' do
    name { Faker::Name.name }
  end

  factory :foo, parent: :foo_faker do
  end

  factory :bar_named_test, class: 'Bar' do
    name { 'test' }
  end

  factory :bar_faker, class: 'Bar' do
    name { Faker::Team.name.titleize }
  end

  factory :bar, parent: :bar_faker do
  end
end
