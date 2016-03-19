class AdminsController < ApplicationController
  before_filter :authenticate_user, :only => [:home, :profile, :setting, :payment, :admin]
  before_filter :save_login_state, :only => [:login, :login_attempt]


  def admin
    if authenticate_user == 'admin'
      render "admin_page"
    else
      redirect_to(:action => 'home', :controller => 'sessions')
    end
  end

  def add_items
    Item.add_item(params[:program], params[:price])
    flash[:notice] = "#{params[:program]} has beed added to programs!"
    redirect_to(:action => 'admin')
  end



end