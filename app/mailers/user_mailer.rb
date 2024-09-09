class UserMailer < ApplicationMailer
    default from: 'module-handbook@infrastructure.de'
  
    def user_approved_mail(email)
      @email = email
      @host = Rails.configuration.x.mh_hostname
      mail(to: email, subject: 'Your account has been approved')
    end
  end