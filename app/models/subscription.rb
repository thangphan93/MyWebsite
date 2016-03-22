class Subscription < ActiveRecord::Base
  attr_accessible :email

  def self.add_email_to_subs(email)
    Subscription.create(:email => email)
  end

  def self.remove_subs(email)
    Subscription.find_by(:email => email).destroy
  end

end
