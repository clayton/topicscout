class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.verify_email.subject
  #
  def verify_email(name, email, code)
    
    @name = name
    @email = email
    @code = code

    mail to: email, from: 'notifications@topicscout.app', subject: 'Please verify your email address'
  end
end
