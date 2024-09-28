
class AdminMailer < Devise::Mailer

  default from: Rails.configuration.x.mh_devise_email
  layout 'mailer'

  def new_user_waiting_for_approval(email)
    @email = email
    deviseEmail = Rails.configuration.x.mh_devise_email
    @host = Rails.configuration.x.mh_hostname
    mail(to: deviseEmail, subject: I18n.t('mailers.admin.new_user'))
  end
end 
