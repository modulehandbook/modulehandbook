class TestLog
  @@log = []
  def self.log(name)
    @@log << name
  end
  def self.getlog
    @@log
  end
  def self.printlog(message)
    if false
      puts message
      puts @@log.inspect
      puts "--------------------------------------------------"
    end
  end
  def self.print(message)
    if false
      puts message
    end
  end
end
