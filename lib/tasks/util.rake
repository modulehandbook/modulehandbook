# frozen_string_literal: true

namespace :util do
  desc 'shortens course codes'
  task clean_codes: :environment do
    courses = Course.all
    courses.each do |c|
      new_code = c.code.gsub('IMI25-', '')
      next unless new_code != c.code

      puts "replace #{c.code} with #{new_code}"
      c.code = new_code
      c.save!
    end
  end
end
