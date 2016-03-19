class Item < ActiveRecord::Base
  attr_accessible :program, :price


  def self.add_item(program, price)
    Item.create(:program => program, :price => price)
  end

  def self.delete_item(program)
    Item.find_by(:program => program).destroy
  end

  def self.update_item(program, new_program, new_price)
    a = Item.find_by(:program => program)
    a.program = new_program
    a.price = new_price
    a.save
  end
end
