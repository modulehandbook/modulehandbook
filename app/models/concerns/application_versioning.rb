module ApplicationVersioning
  extend ActiveSupport::Concern

  included do
    self.primary_key = :id, :valid_end
  end

  class_methods do
    def all_valid_at(valid_at)
      parsed_date = parse_date(valid_at)
      query = "SELECT * FROM #{table_name} WHERE ? BETWEEN valid_start AND valid_end"
      return find_by_sql [query, parsed_date]
    end

    def order_valid_at(valid_at, *order_attributes)
      parsed_date = parse_date(valid_at)
      order_attributes_s = order_attributes.join(", ")
      query = "SELECT * FROM #{table_name} WHERE ? BETWEEN valid_start AND valid_end ORDER BY #{order_attributes_s} ASC"
      return find_by_sql [query, parsed_date]
    end

    def parse_date(date)
      if date.is_a? Date
        return date
      end

      Date.parse(date)
    end
  end

end