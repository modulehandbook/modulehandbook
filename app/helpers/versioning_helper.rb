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

  def split_to_id_and_valid_end(composite_key)
    if composite_key.is_a? Array
      return composite_key
    end

    if composite_key.include?(",")
      return composite_key.split(",")
    end

    if composite_key.include?(" ")
      return composite_key.split(" ")
    end

    composite_key
  end

  def get_semester_name(valid_end)
    "#{get_semester_season(valid_end)} #{get_semester_year(valid_end)}"
  end

  def get_semester_season(valid_end)
    if valid_end.month == 1 # January
      "Winter"
    elsif valid_end.month == 6 # June
      "Spring"
    else
      "Unknown Semester"
    end
  end

  def get_semester_year(valid_end)
    if valid_end.month == 1 # January
      valid_end.year - 1
    else
      valid_end.year
    end
  end

  def get_valid_end_from_season_and_year(season, year)
    if season == "Winter"
      Date.parse("#{year + 1}-01-31")
    else
      Date.parse("#{year}-06-30")
    end
  end

  def get_valid_start_from_valid_end(valid_end)
    if valid_end.month == 1 # January
      Date.parse("#{valid_end.year - 1}-09-01")
    else
      Date.parse("#{valid_end.year}-02-01")
    end
  end

end
