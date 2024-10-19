# frozen_string_literal: true

class TestLog
  @@log = []
  def self.log(name)
    @@log << name
  end

  def self.getlog
    @@log
  end

  def self.printlog(message)
    return unless false

    puts message
    puts @@log.inspect
    puts '--------------------------------------------------'
  end

  def self.print(message)
    return unless false

    puts message
  end
end
