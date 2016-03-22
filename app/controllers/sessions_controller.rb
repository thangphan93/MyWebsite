class SessionsController < ApplicationController
  before_filter :authenticate_user, :only => [:home, :profile, :setting, :payment, :admin]
  before_filter :save_login_state, :only => [:login, :login_attempt]
  attr_accessor :items

  def login
  end

  def get_user
    @current_user = User.find_by(:auth_token => cookies[:auth_token])#User.find session[:user_id]
    @current_item = Item.find_by(:program => params[:program])
  end

  def login_attempt
    authorized_user = User.authenticate(params[:username_or_email],params[:login_password])

    if authorized_user
      if params[:remember_me] #NEW
        cookies.permanent[:auth_token] = authorized_user.auth_token #NEW
        flash[:notice] = "YES remember" #DEBUG LITTLE BIT

      else
        flash[:notice] = "NO remember" #DEBUG LITTLE BIT
        cookies[:auth_token] = authorized_user.auth_token #NEW
      end
      #session[:user_id] = authorized_user.id
      redirect_to home_path #(:action => 'home')
    else
      flash[:notice] = "Invalid Username or Password"
      flash[:color]= "invalid"
      render "login"
    end
  end

  def change_password
    authorized_user = User.authenticate(params[:username_or_email],params[:login_password])
    #@current_user = User.find session[:user_id]
    @current_user = User.find_by(:auth_token => cookies[:auth_token])

    if @current_user == authorized_user
      UserMailer.change_pw_confirmed(authorized_user).deliver_now
      User.change_pw(params[:username_or_email], params[:login_new_password])
      flash[:notice] = "Your password has been changed! :)"
      redirect_to setting_path
    else
      flash[:error]= "Your old password/username/email does not match"
      redirect_to setting_path
    end
  end

  def logout
    #session[:user_id] = nil
    cookies.delete(:auth_token) #NEW
    redirect_to :action => 'login'
  end

  def add_gender!
    @current_user = User.find_by(:auth_token => cookies[:auth_token])
    #@current_user = User.find session[:user_id]
    if params[:gender].nil?
      return false
    else
      User.add_genders(params[:gender], @current_user)
      return true
    end
  end

  def choose_program
    #@current_user = User.find session[:user_id]
    @current_user = User.find_by(:auth_token => cookies[:auth_token])
    @current_item = Item.find_by(:program => params[:program])

    if add_gender!
      if @current_item.blank?
        flash[:notice] = "You have to choose one program! Don't leave it blank."
        redirect_to home_path #(:action => 'home')
      else
        session[:program] = @current_item.program
        session[:price] = @current_item.price
        User.add_program(params[:program], @current_user)
        redirect_to payment_path #(:action => 'payment')
      end
    else
      flash[:notice] = "You have to choose gender before program! Don't leave it blank."
      redirect_to home_path #(:action => 'home')
    end
  end

  def reset_pw
    if User.find_user_email(params[:email])
      new_password = (0...8).map { (65 + rand(26)).chr }.join
      User.change_pw(params[:email], new_password)
      change_this_user = User.find_by(:email => params[:email])
      UserMailer.reset_pw_confirmed(change_this_user, new_password).deliver_now
      flash[:notice] = "Please check your email for reset, log in with the new password!"
      redirect_to login_path #(:action => 'login')
    else
      flash[:notice] = "You email is not valid, try again"
      render "reset_password"
    end
  end
end
