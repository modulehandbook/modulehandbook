class AdminMailer < Devise::Mailer
    default from: 'module-handbook@infrastructure.de'
    layout 'mailer'

    def new_user_waiting_for_approval(email)
      @email = email
      mail(to: 'module-handbook@infrastructure.de', subject: 'Module Handbook: New User Awaiting Admin Approval')
    end
  end
