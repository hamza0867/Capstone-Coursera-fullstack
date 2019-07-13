# frozen_string_literal: true

class AddThingsConstraints < ActiveRecord::Migration[5.2]
  def up
    change_column :things, :name, :string, null: false
  end

  def down
    change_column :things, :name, :string, null: true
  end
end
