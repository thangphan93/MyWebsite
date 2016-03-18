class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :program
      t.integer :price

      t.timestamps null: false
    end
  end
end
