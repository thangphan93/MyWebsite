class Item < ActiveRecord::Base
  attr_accessible :program, :price, :picture


  def self.add_item(program, price, pic)
    Item.create(:program => program, :price => price, :picture => pic)
  end

  def self.delete_item(program)
    Item.find_by(:program => program).destroy
  end

  def self.update_item(program, new_program, new_price, new_pic)
    a = Item.find_by(:program => program)
    a.program = new_program
    a.price = new_price
    a.picture = new_pic
    a.save
  end

  def self.get_program_picture(program)
    a = Item.find_by(:program => program)
    return a.picture
  end
end
