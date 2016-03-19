class Item < ActiveRecord::Base
  attr_accessible :program, :price


  def self.add_item(program, price)
    Item.create(:program => program, :price => price)
  end
end
