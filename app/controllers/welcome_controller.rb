# frozen_string_literal: true

class WelcomeController < ApplicationController
  skip_authorization_check
  skip_before_action :authenticate_user!

   
  def index
   
    if params[:allow_redirect] == 'false' 
      do_redirect = false
    else
      do_redirect = ENV['PROGRAM_ROOT'] || false
    end
    #do_redirect = false
    program_id = 9
    if do_redirect 
      #redirect_to proc { eval(ENV['LANDING_PATH']) }
      redirect_to proc { program_path(program_id) }
    end
    
  end
end
