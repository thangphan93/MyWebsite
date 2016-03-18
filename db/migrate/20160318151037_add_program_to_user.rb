class AddProgramToUser < ActiveRecord::Migration
  def change
    add_column :users, :program, :string
  end
end
