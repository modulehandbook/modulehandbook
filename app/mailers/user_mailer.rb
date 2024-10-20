# frozen_string_literal: true

class UserMailer < ApplicationMailer
    default from: 'module-handbook@infrastructure.de'
  
    def user_approved_mail(email)
      @email = email
      @host = Rails.configuration.x.mh_hostname
      mail(to: email, subject: I18n.t('mailers.user.account_approved'))
    end
  end
