class UserMailer < ActionMailer::Base
  default from: "admin@campanarium.com"

  def user_banned_email(user)
    @user = user

    mail(to: @user.email, subject: "Tu cuenta ha sido suspendida")
  end
end