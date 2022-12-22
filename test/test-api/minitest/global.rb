class TestLog
  @@log = []
  def self.log(name)
    @@log << name
  end
  def self.getlog
    @@log
  end
end
