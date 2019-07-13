# frozen_string_literal: true

# Thing Image Relationship class
class ThingImage < ApplicationRecord
  belongs_to :image
  belongs_to :thing

  validates :image, :thing, presence: true

  scope :prioritized, -> { order(priority: :asc) }
  scope :things,     -> { where(priority: 0) }
  scope :primary,    -> { where(priority: 0).first }

  scope :with_thing, lambda  {
                       joins('left outer join things on things.id = thing_images.thing_id')
                         .select('thing_images.*')
                     }
  scope :with_image, lambda  {
                       joins('right outer join images on images.id = thing_images.image_id')
                         .select('thing_images.*', 'images.id as image_id')
                     }

  scope :with_name,    -> { with_thing.select('things.name as thing_name') }
  scope :with_caption, -> { with_image.select('images.caption as image_caption') }
end
