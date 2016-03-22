class ApplicationController < ActionController::Base
  #before_filter :authenticate_user
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  protected
  def authenticate_user
    if cookies[:auth_token]#session[:user_id]
      # set current user object to @current_user object variable
      @items = Item.all.map{|i| [ i.program]} #Add all items to this variable at start when rendering logging in.
      #@current_user = User.find session[:user_id]
      @current_user = User.find_by(:auth_token => cookies[:auth_token]) if cookies[:auth_token]
      if @current_user.admin?
        return 'admin'
      end
      return true
    else
      redirect_to login_path
      return false
    end
  end

  def save_login_state
    if cookies[:auth_token] #session[:user_id]
      redirect_to home_path
      return false
    else
      return true
    end
  end

  def load_user_and_subs
    @current_user = User.find_by(:auth_token => cookies[:auth_token]) if cookies[:auth_token]

    @subs = Subscription.find_by(:email => @current_user.email)

  end
end
