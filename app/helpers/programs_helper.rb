# frozen_string_literal: true

module ProgramsHelper

  #
  def htw_sws(course)
    su = course.lectureHrs || 0
    lab = course.labHrs || 0

    return "#{pn(lab)}" if su == 0
    return "#{pn(su)}" if lab == 0

    "#{pn(su)}/#{pn(lab)}"
  end
  def pn(n)
    return "" if n == 0
    "#{'%.0f' % n}"
  end

  def htw_form(course)
    su = course.lectureHrs || 0
    lab = course.labHrs || 0

    return "Ü" if su == 0
    return "SL" if lab == 0

    "SL/Ü"
  end



end
