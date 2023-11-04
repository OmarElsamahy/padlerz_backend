class UserMailer < ApplicationMailer
  def email_confirmation(user)
    @user = user
    @user_type = user.class
    mail(to: @user.email_to_verify, :subject => "Email Confirmation")
  end

  def reset_password_confirmation(user)
    @user = user
    @user_type = user.class
    mail(to: @user.email, :subject => "Reset Password")
  end
end
