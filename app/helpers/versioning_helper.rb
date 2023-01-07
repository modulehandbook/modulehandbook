module VersioningHelper
  def set_current_as_of_time
    if params[:as_of_time] && params[:as_of_time] != ""
      time = params[:as_of_time]
      @current_as_of_time = Time.parse(time).to_formatted_s(:default)
    else
      @current_as_of_time = Time.zone.now.to_formatted_s(:default)
    end
  end

  def is_latest_version
    current_time = Time.zone.now
    current_time_s = current_time.strftime("%Y-%m-%d %H:%M:%S")

    current_as_of_time = Time.parse(@current_as_of_time).strftime("%Y-%m-%d %H:%M:%S")
    parsed_current_as_of_time = Time.parse(@current_as_of_time)

    # Equality check done on string to ignore variations in milliseconds
    # 'Before' check done using Time objects
    current_time_s == current_as_of_time || current_time.before?(parsed_current_as_of_time)
  end

  def set_current_semester
    season = params[:current_semester_season]
    year = params[:current_semester_year]
    if season && year
      @current_semester = get_valid_end_from_season_and_year(season, year.to_i)
    else
      # Last element is latest semester
      @current_semester = @existing_semesters[-1]
    end

  end

  def set_current_semester_in_show
    season = params[:current_semester_season]
    year = params[:current_semester_year]
    id = params[:id]
    if id && !season && !year
      split = split_to_id_and_valid_end(id)
      @current_semester = Date.parse(split[1])
    else
      set_current_semester
    end
  end

  def is_selected_different_semester(valid_end_s)
    @current_semester != Date.parse(valid_end_s)
  end

  def get_existing_semester_seasons
    has_winter = @existing_semesters.find { |semester| semester.month == 1 }
    has_spring = @existing_semesters.find { |semester| semester.month == 6 }
    seasons = []

    if has_winter
      seasons.append("Winter")
    end

    if has_spring
      seasons.append("Spring")
    end

    seasons
  end

  def get_existing_semester_years
    years = []
    @existing_semesters.each do |semester|
      years.append(get_semester_year(semester))
    end

    years.uniq.sort
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
