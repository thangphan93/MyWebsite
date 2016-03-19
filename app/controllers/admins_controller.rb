class AdminsController < ApplicationController
  before_filter :authenticate_user, :only => [:home, :profile, :setting, :payment, :admin]
  before_filter :save_login_state, :only => [:login, :login_attempt]


  def admin
    @items = Item.all.map{|i| [ i.program ] }
    if authenticate_user == 'admin'
      render "admin_page"
    else
      redirect_to(:action => 'home', :controller => 'sessions')
    end
  end

  def add_items #create
    Item.add_item(params[:program], params[:price], params[:picture])
    flash[:notice] = "#{params[:program]} has been added to programs!"
    redirect_to(:action => 'admin')
  end

  def update_items #update
    Item.update_item(params[:program], params[:new_program], params[:new_price], params[:new_picture])
    flash[:notice] = "#{params[:program]} has been updated to #{params[:new_program]} with price: #{params[:new_price]}"
    redirect_to(:action => 'admin')
  end

  def delete_items #delete
    Item.delete_item(params[:program])
    flash[:notice] = "#{params[:program]} has been deleted!"
    redirect_to(:action => 'admin')
  end



end