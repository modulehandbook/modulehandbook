module CombinedVersioning
  extend ActiveSupport::Concern
  include SystemVersioning
  include ApplicationVersioning


  class_methods do
    def all_valid_at_as_of(valid_at, as_of_time)
      parsed_time = parse_time(as_of_time)
      parsed_date = parse_date(valid_at)
      query = "SELECT * FROM #{table_name} FOR SYSTEM_TIME AS OF TIMESTAMP? WHERE ? BETWEEN valid_start AND valid_end"
      return find_by_sql [query, parsed_time, parsed_date]
    end

    def order_valid_at_as_of(valid_at, as_of_time, *order_attributes)
      parsed_time = parse_time(as_of_time)
      parsed_date = parse_date(valid_at)
      order_attributes_s = order_attributes.join(", ")
      query = "SELECT * FROM #{table_name} FOR SYSTEM_TIME AS OF TIMESTAMP? WHERE ? BETWEEN valid_start AND valid_end ORDER BY #{order_attributes_s} ASC"
      return find_by_sql [query, parsed_time, parsed_date]
    end
  end

end