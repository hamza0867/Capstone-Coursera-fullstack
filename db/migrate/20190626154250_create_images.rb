# frozen_string_literal: true

class CreateImages < ActiveRecord::Migration[5.2]
  def change
    create_table :images do |t|
      t.string :caption
      t.integer :creator_id, null: false

      t.timestamps null: false
    end
    add_index :images, :creator_id
  end
end
