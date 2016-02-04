class CreateInputfiles < ActiveRecord::Migration
  def change
    create_table :inputfiles do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.string :attachment, null: false

      t.timestamps null: false
    end
  end
end
