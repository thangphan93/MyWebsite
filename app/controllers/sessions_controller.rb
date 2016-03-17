class SessionsController < ApplicationController
  before_filter :authenticate_user, :only => [:home, :profile, :setting]
  before_filter :save_login_state, :only => [:login, :login_attempt]
  def login
  end

  def login_attempt
    authorized_user = User.authenticate(params[:username_or_email],params[:login_password])
    if authorized_user
      session[:user_id] = authorized_user.id
      redirect_to(:action => 'home')
    else
      flash[:notice] = "Invalid Username or Password"
      flash[:color]= "invalid"
      render "login"
    end
  end

  def change_password
    authorized_user = User.authenticate(params[:username_or_email],params[:login_password])
    @current_user = User.find session[:user_id]

    if @current_user == authorized_user
      UserMailer.change_pw_confirmed(authorized_user).deliver_now
      User.change_pw(params[:username_or_email], params[:login_new_password])
      flash[:notice] = "Your password has been changed! Log in with your new password :)"
      render "login"
    else
      flash[:notice] = "Your old password/username/email does not match"
      redirect_to :action => 'setting'
    end
  end

  def send_random_tactic
    authorized_user = User.authenticate(params[:username_or_email],params[:login_password])
    @current_user = User.find session[:user_id]
    UserMailer.send_random_tactic(authorized_user).deliver_now
    render "home"
  end

  def logout
    session[:user_id] = nil
    redirect_to :action => 'login'
  end

  def home
    render "home"
  end

  def profile
    render "profile"
  end

  def setting
    render "setting"
  end
end
