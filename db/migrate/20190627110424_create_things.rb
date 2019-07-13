class CreateThings < ActiveRecord::Migration[5.2]
  def change
    create_table :things do |t|
      t.string :name, null: false
      t.text :description
      t.text :notes

      t.timestamps
    end
  end
end
