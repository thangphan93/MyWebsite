class SessionsController < ApplicationController
  before_filter :authenticate_user, :only => [:home, :profile, :setting, :payment]
  before_filter :save_login_state, :only => [:login, :login_attempt]

  attr_accessor :items

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
      flash[:notice] = "Your password has been changed! :)"
      redirect_to(:action => 'setting')
    else
      flash[:error]= "Your old password/username/email does not match"
      redirect_to :action => 'setting'
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to :action => 'login'
  end

  def add_gender
    @current_user = User.find session[:user_id]
    User.add_genders(params[:gender], @current_user)
    flash[:notice] = "Gender is changed"
    render "home"
  end

  def choose_program

    @current_user = User.find session[:user_id]

    @current_item = Item.find_by(:program => params[:program])

    session[:program] = @current_item.program # TODO: No need for session. FIX THIS.
    session[:price] = @current_item.price
    User.add_program(params[:program], @current_user)

    redirect_to(:action => 'payment')
  end

  def reset_pw
    if User.find_user_email(params[:email])
      new_password = (0...8).map { (65 + rand(26)).chr }.join
      User.change_pw(params[:email], new_password)
      change_this_user = User.find_by(:email => params[:email])
      UserMailer.reset_pw_confirmed(change_this_user, new_password).deliver_now
      flash[:notice] = "Please check your email for reset, log in with the new password!"
      redirect_to(:action => 'login')
    else
      flash[:notice] = "You email is not valid, try again"
      render "reset_password"
    end

  end

  def checkout
    #redirect_to @sessions.paypal_url("home")
    render "home"
  end


  def reset_password
    render "reset_password"
  end

  def home
    @items = Item.all.map{|i| [ i.program ] } #Add all items to this variable at start when rendering "home"
    render "home"
  end

  def profile
    render "profile"
  end

  def setting
    render "setting"
  end
end
