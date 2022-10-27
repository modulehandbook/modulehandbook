
# Turbo does not work Devise out of the box
# Issue on GitHub: https://github.com/heartcombo/devise/issues/5446
# Workaround/fix: https://gorails.com/episodes/devise-hotwire-turbo & https://betterprogramming.pub/devise-auth-setup-in-rails-7-44240aaed4be
#
class TurboDeviseController < ApplicationController
  class Responder < ActionController::Responder
    def to_turbo_stream
      controller.render(options.merge(formats: :html))
    rescue ActionView::MissingTemplate => error
      if get?
        raise error
      elsif has_errors? && default_action
        render rendering_options.merge(formats: :html, status: :unprocessable_entity)
      else
        redirect_to navigation_location
      end
    end
  end

  self.responder = Responder
  respond_to :html, :turbo_stream
end
