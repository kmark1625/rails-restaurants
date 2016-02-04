class CreateInputfiles < ActiveRecord::Migration
  def change
    create_table :inputfiles do |t|
      t.string :name
      t.string :description
      t.string :attachment

      t.timestamps null: false
    end
  end
end
