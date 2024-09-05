
class AdminMailer < Devise::Mailer

  default from: Rails.configuration.x.mh_devise_email
  layout 'mailer'

  def new_user_waiting_for_approval(email)
    @email = email
    deviseEmail = Rails.configuration.x.mh_devise_email
    @host = Rails.configuration.x.mh_hostname
    @host_with_protocol = @host.start_with?('http://', 'https://') ? @host : "http://#{@host}"
    mail(to: deviseEmail, subject: 'Module Handbook: New User Awaiting Admin Approval')
  end
end
