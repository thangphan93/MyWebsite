class UserMailer < ApplicationMailer
  include SendGrid

  def welcome_email(user)
    @user = user
    mail to: @user.email, subject: "Velkommen!"
  end

  def change_pw_confirmed(user)
    @user = user
    mail to: @user.email, subject: "Password changed successfully! :)"
  end

  def reset_pw_confirmed(user, new_password)
    @user = user
    @pw = new_password
    @url = "http://localhost:3000/setting"
    mail to: @user.email, subject: "Your password has been reset"
  end

  def deliver_product(current_user, current_item)
    @user = current_user
    @item = current_item

    mail to: @user.email, subject: "Here are your delivery!"
  end

  def send_news_to_sub(email)
    mail to: email, subject: "Great news! New products for you!"
  end
end
