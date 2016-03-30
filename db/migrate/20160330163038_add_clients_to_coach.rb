class AddClientsToCoach < ActiveRecord::Migration
  def change
    add_column :coaches, :clients, :integer, :default => 0
  end
end
