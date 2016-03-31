class SessionsController < ApplicationController
  include SessionsHelper
  before_filter :authenticate_user, :only => [:home, :profile, :setting, :payment, :admin]
  before_filter :save_login_state, :only => [:login, :login_attempt]
  before_action :load_user_and_subs, :only =>[:home, :profile, :setting, :payment, :admin]
  attr_accessor :items
  before_action :get_user #Put this here to use @current_user all place in here


  def login
  end

  def get_user
    @current_user = User.find_by(:auth_token => cookies[:auth_token])#User.find session[:user_id]
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
    if params[:gender].nil?
      return false
    else
      User.add_genders(params[:gender], @current_user)
      return true
    end
  end

  def choose_program
    @current_user = User.find_by(:auth_token => cookies[:auth_token])
    @current_item = Item.find_by(:program => params[:program])
    if add_gender!
      if @current_item.blank?
        flash[:notice] = "You have to choose one program! Don't leave it blank."
        redirect_to home_path #(:action => 'home')
      else
        session[:program] = @current_item.program
        session[:price] = @current_item.price

        if check_coach_valid #Check if user have selected coaching
          session[:couch?] = true #Set to true so user sees all coaches in payment view.
          flash[:notice] = "Coach is selected" #TODO: Change this to use coach table(database)
          User.add_program(params[:program], @current_user)
          redirect_to payment_path #(:action => 'payment')

        else
          User.add_program(params[:program], @current_user)
          redirect_to payment_path
        end
      end
    else
      flash[:notice] = "You have to choose gender before program! Don't leave it blank."
      redirect_to home_path
    end
  end

  def check_coach_valid
    session[:couch?] = false #Set to false so user can chose yes or no everytime one purchase is made.
    return params[:need_coach?]
  end

  def select_coach
    @current_user = User.find_by(:auth_token => cookies[:auth_token])


=begin #DELETE ALL CLIENTS TO COACHES AND ALL COACH_ID FROM USERS!
    for item in Coach.all do
      item.clients = 0
      item.save
    end

    for it in User.all do
      it.coach_id = nil
      it.save
    end
=end

    if params[:coach].blank?
      flash[:notice] = "You have to chose a coach"
      redirect_to(:back)#redirect_to payment_path
    elsif @current_user.change_limit == 0
      flash[:notice] = "You have no more changes, contact lyern52@gmail.com if urgent!"
      redirect_to(:back)#redirect_to payment_path

    else
      a = Coach.find_by(:name => params[:coach]) #Selected coach
      b = Coach.find_by(:id => @current_user.coach_id) #Old coach

      change_coach_helper(a,b,@current_user) #Calling helper method.

      flash[:notice] = "You have chosen the coach: #{a.name}. You will be charged 20$"
      redirect_to(:back)#redirect_to payment_path
    end
  end

  def home
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

  def status
    @coaches = Coach.all.map{|c| [c.name]}
    session[:change_coach] = true
    render 'status'
  end
  #----------SUBS----------#
  def add_subscription
    Subscription.add_email_to_subs(@current_user.email)
    flash[:notice] = "You have successfully subscribed to .. with #{@current_user.email}. You will recieve the newest news!"
    redirect_to setting_path
  end

  def remove_subscription
    Subscription.remove_subs(@current_user.email)
    flash[:notice] = "You have successfully unsubscribed to .. with #{@current_user.email}"
    redirect_to setting_path
  end
end
