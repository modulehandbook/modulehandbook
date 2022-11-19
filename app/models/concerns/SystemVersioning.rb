module SystemVersioning
  extend ActiveSupport::Concern

  included do
    def versions
      query = "SELECT * FROM #{self.class.table_name} FOR SYSTEM_TIME ALL WHERE id = ? ORDER BY transaction_end DESC"
      self.class.find_by_sql [query, self[:id]]
    end
  end

  class_methods do

  end

end