module VersioningHelper
  def set_current_as_of_time
    if params[:as_of_time] && params[:as_of_time] != ""
      time = params[:as_of_time]
      @current_as_of_time = Time.parse(time).to_formatted_s(:db)
    else
      @current_as_of_time = Time.now.to_formatted_s(:db)
    end
  end

  def is_latest_version
    current_time = Time.now
    current_time_s = current_time.to_formatted_s(:db)

    parsed_current_as_of_time = Time.parse(@current_as_of_time)

    # Equality check done on string to ignore variations in milliseconds
    # 'Before' check done using Time objects
    current_time_s == @current_as_of_time || current_time.before?(parsed_current_as_of_time)
  end
end
