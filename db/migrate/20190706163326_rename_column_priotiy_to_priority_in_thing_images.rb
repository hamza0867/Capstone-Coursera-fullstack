# frozen_string_literal: true

class RenameColumnPriotiyToPriorityInThingImages < ActiveRecord::Migration[5.2]
  def change
    rename_column :thing_images, :priotiy, :priority
  end
end
