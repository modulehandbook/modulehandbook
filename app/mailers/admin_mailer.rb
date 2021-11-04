
class AdminMailer < Devise::Mailer

  @@deviseEmail = ENV['DEVISE_EMAIL']
  @@deviseEmail ||= 'module-handbook@infrastructure.de'

  default from: @@deviseEmail
  layout 'mailer'

  def new_user_waiting_for_approval(email)
    @email = email
    mail(to: @@deviseEmail, subject: 'Module Handbook: New User Awaiting Admin Approval')
  end
end
