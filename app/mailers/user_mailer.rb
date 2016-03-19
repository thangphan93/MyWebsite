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
end
