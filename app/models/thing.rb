# frozen_string_literal: true

class Thing < ApplicationRecord
  validates :name, presence: true

  has_many :thing_images, inverse_of: :thing, dependent: :destroy
  scope :not_linked, lambda { |image|
                       where.not(id: ThingImage.select(:thing_id)
                                                                .where(image: image))
                     }
end
