# frozen_string_literal: true

class CreateThingImages < ActiveRecord::Migration[5.2]
  def change
    create_table :thing_images do |t|
      t.references :image, index: true, foreign_key: true, null: false
      t.references :thing, index: true, foreign_key: true, null: false
      t.integer :priotiy, null: false, default: 5
      t.integer :creator_id, null: false

      t.timestamps
    end
    add_index :thing_images, %i[image_id thing_id], unique: true
  end
end