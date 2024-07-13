
class NudgeController < ApplicationController
    skip_authorization_check
    # authorize_resource :class => false
    skip_before_action :authenticate_user!
    def nudge
        begin
          file_name = DateTime.now.strftime("nudge/nudge-%Y-%m-%d---%H-%M-%S")
          @tag = params['tag']
          File.open(file_name, 'w') { |file| file.write(@tag) }
          @nudge_result = "ok - #{@tag} - #{file_name}"
        rescue Exception => e
            @nudge_result = e
        end

    end
end
