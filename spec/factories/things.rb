# frozen_string_literal: true

FactoryGirl.define do
  factory :thing do
    name { Faker::Commerce.product_name }
    description { Faker::Restaurant.description }
    notes { Faker::Restaurant.review }

    trait :with_image do
      transient do
        image_count 1
      end

      after :build do |thing, props|
        thing.thing_images << build_list(:thing_image, props.image_count,
                                         thing: thing)
      end
    end
  end
end
