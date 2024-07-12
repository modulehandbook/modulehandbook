
class NudgeController < ApplicationController
    authorize_resource :class => false
    def nudge
        begin
          # https://ruby-doc.org/core-3.1.2/DateTime.html
          file_name = DateTime.now.strftime("nudge/nudge-%Y-%m-%d---%H-%M-%S")
          @tag = params['tag']
          File.open(file_name, 'w') { |file| file.write(@tag) }
          @nudge_result = "ok - #{@tag} - #{file_name}"
        rescue Exception => e
            @nudge_result = e
        end

    end
end
