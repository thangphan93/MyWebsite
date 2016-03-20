class ApplicationController < ActionController::Base
  #before_filter :authenticate_user
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  protected
  def authenticate_user
    if session[:user_id]
      # set current user object to @current_user object variable
      @items = Item.all.map{|i| [ i.program ] } #Add all items to this variable at start when rendering logging in.
      @current_user = User.find session[:user_id]
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
    if session[:user_id]
      redirect_to home_path
      return false
    else
      return true
    end
  end
end
