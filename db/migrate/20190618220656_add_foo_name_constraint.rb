# frozen_string_literal: true

class AddFooNameConstraint < ActiveRecord::Migration[5.2]
  def up
    change_column :foos, :name, :string, null: false
  end

  def down
    change_column :foos, :name, :string, null: true
  end
end
