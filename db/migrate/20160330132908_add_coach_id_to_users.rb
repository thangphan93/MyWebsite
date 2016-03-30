class AddCoachIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :coach_id, :string
    add_index :users, :coach_id
  end
end
