module VersioningHelper
  def set_current_as_of_time
    if params[:as_of_time] && params[:as_of_time] != ""
      @current_as_of_time = params[:as_of_time]
    else
      @current_as_of_time = Time.now.to_formatted_s(:db)
    end
  end
end
