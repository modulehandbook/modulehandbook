module VersionsHelper

  def papertrail_author(papertrail_version)
    return "No user" unless wd = papertrail_version.whodunnit
    return "no user" unless u = User.find_by(id: wd)
    return u.email
  end
end
