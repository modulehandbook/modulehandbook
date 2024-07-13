
class NudgeController < ApplicationController
    skip_authorization_check
    # authorize_resource :class => false
    skip_before_action :authenticate_user!
    def nudge
        
        tag = params['tag']
        sha = params['sha']
        key = params['key']
        if key != Rails.application.credentials.nudge_key 
          @nudge_result = "Not authorized"
          redirect_to root, :status => 301
          return
        else  
            begin
              message = "tag: #{tag}\nsha: #{sha}"
            
              file_name = DateTime.now.strftime("nudge/nudge-%Y-%m-%d---%H-%M-%S")
            
              File.open(file_name, 'w') { |file| file.write(message) }
              File.open("nudge/tag", 'w') { |file| file.write(tag) }
              File.open("nudge/sha", 'w') { |file| file.write(sha) }
            
              @nudge_result = "ok - #{@tag}/#{@sha} - #{file_name}"
            rescue Exception => e
                @nudge_result = e
            end
        end

    end
end
