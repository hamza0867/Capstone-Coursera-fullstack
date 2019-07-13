# frozen_string_literal: true

FactoryGirl.define do
  factory :image do
    sequence(:caption) { |n| n.even? ? nil : Faker::Lorem.sentence(1).chomp('.') }
    creator_id 1

    trait :with_caption do
      caption { Faker::Lorem.sentence(1) }
    end
  end
end
