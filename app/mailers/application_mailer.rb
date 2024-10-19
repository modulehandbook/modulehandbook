# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'module-handbook@infrastructure.de'
  layout 'mailer'
end
