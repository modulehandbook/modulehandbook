
class NudgeController < ApplicationController
    skip_authorization_check
    # authorize_resource :class => false
    skip_before_action :authenticate_user!
    def nudge
        begin
          tag = params['tag']
          sha = params['sha']
          
          message = "tag: #{tag}\nsha: #{sha}"
          
          file_name = DateTime.now.strftime("nudge/nudge-%Y-%m-%d---%H-%M-%S")
        
          File.open(file_name, 'w') { |file| file.write(message) }
          File.open("nudge/tag", 'w') { |file| file.write(tag) }
          File.open("nudge/sha", 'w') { |file| file.write(sha) }
          
          @nudge_result = "ok - #{@tag}/#{@sha} - #{file_name}"
        rescue Exception => e
            @nudge_result = e
        end
#sha=9c17420beb4e38f5cdfc3a4f62fa3964de705d28
#tag=sha-9c17420
    end
end
