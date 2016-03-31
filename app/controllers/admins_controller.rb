class AdminsController < ApplicationController
  include SessionsHelper
  before_filter :authenticate_user, :only => [:home, :profile, :setting, :payment, :admin, :search_user]
  before_filter :save_login_state, :only => [:login, :login_attempt]
  before_action :get_searched_user


  def admin
    @items = Item.all.map{|i| [ i.program ] }
    if authenticate_user == 'admin' #Method in parent class to return admin, true or false.
      render "admin_page"
    else
      flash[:notice] = "You are not an admin, contact 'lyern52@gmail.com'"
      redirect_to root_url
    end
  end

  def add_items #create
    Item.add_item(params[:program], params[:price], params[:picture])

    Subscription.find_each do |sub| #Send email to all subs about the newest product!
      UserMailer.send_news_to_sub(sub.email, Item.last).deliver_now #Item.last give last added element/item.
    end
    flash[:notice] = "#{params[:program]} has been added to programs!"
    redirect_to adminpage_path
  end

  def update_items #update
    Item.update_item(params[:program], params[:new_program], params[:new_price], params[:new_picture])
    flash[:notice] = "#{params[:program]} has been updated to #{params[:new_program]} with price: #{params[:new_price]}"
    redirect_to adminpage_path
  end

  def delete_items #delete
    Item.delete_item(params[:program])
    flash[:notice] = "#{params[:program]} has been deleted!"
    redirect_to adminpage_path
  end

  def search_user
    render 'admin_search_user'
  end

  def get_searched_user
    if params[:user_or_email].nil?
    else
      session[:keep_user] = params[:user_or_email]
    end
    @that_user = User.check_username_email(session[:keep_user])
  end

  def update_change_limit
    if params[:limit].blank?
      flash[:notice] = "Cannot be blank!"
    else
      if params[:limit] > "3"
        flash[:notice] = "System not allowing more than 3 coach changes!"
      else
        @that_user.change_limit = params[:limit]
        @that_user.save
      end
    end

    redirect_to (:back)
  end

  def update_coach
    a = Coach.find_by(:name => params[:coach]) #Selected coach
    b = Coach.find_by(:id => @that_user.coach_id) #Old coach

    change_coach_helper(a, b, @that_user) #Calling helper method in SessionsHelper.

    flash[:notice] = "Changes successful!"
    redirect_to (:back)
  end

  def delete_user
    @that_user.destroy
    redirect_to (:back)
  end

end