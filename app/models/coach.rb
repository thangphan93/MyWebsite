class Coach < ActiveRecord::Base
  has_many :users
  attr_accessible  :id, :name, :limit, :clients

  def self.add_clients(coach)
    coach.clients = coach.clients+1
    coach.save
  end

  def self.remove_clients(coach)
    coach.clients = coach.clients-1
    coach.save
  end

end
