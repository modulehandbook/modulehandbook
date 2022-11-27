class SetDatabaseTimeZoneToUtc < ActiveRecord::Migration[7.0]

  # This ensures database uses UTC.
  # MySQL (and MariaDB) installations use the system time zone by default for timezones
  # which can lead to issues and inconsistencies especially since Rails automatically converts time zones
  #
  # This makes sure that time zone is updated to use UTC in MariaDB (https://mariadb.com/kb/en/time-zones/)
  def change
    execute <<-SQL
      SET GLOBAL time_zone = '+00:00';
    SQL
  end
end
