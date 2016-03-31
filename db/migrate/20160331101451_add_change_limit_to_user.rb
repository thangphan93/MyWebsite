class AddChangeLimitToUser < ActiveRecord::Migration
  def change
    add_column :users, :change_limit, :integer, :default => 3
  end
end
