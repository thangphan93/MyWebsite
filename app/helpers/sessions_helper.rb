module SessionsHelper
  def change_coach_helper(a, b, user)
    Coach.add_clients(a) #Add new coach here
    if !b.nil?
      User.count_change_limit(user) #This will count amount of changes of a coach. Max 3.
      Coach.remove_clients(b) #Remove old client
    end

    User.add_coach(a, user) #TODO: SOMETHING WRONG?
  end
end
