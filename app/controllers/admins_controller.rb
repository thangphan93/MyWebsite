class AdminsController < ApplicationController
  before_filter :authenticate_user, :only => [:home, :profile, :setting, :payment, :admin]
  before_filter :save_login_state, :only => [:login, :login_attempt]


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
      UserMailer.send_news_to_sub(sub.email).deliver_now
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
end