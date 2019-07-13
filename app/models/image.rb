# frozen_string_literal: true

class Image < ApplicationRecord
  has_many :thing_images, inverse_of: :image, dependent: :destroy
  has_many :things, through: :thing_images
end
