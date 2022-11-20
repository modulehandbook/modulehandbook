module SystemVersioning
  extend ActiveSupport::Concern

  included do
    before_save :add_author, :add_change_list


    def versions
      query = "SELECT * FROM #{self.class.table_name} FOR SYSTEM_TIME ALL WHERE id = ? ORDER BY transaction_end ASC"
      self.class.find_by_sql [query, self[:id]]
    end

    private
    def add_author
      user = Thread.current[:current_user]
      if user
        self.author_id = user.id
      end
    end

    def add_change_list
      change_list = get_change_list
      self.change_list = change_list
    end
    def get_change_list
      change_list = ""
      self.changes.each do |attr_name, change|
        if attr_name == "author_id" || attr_name == "change_list"
          next
        end
        change_text = ""
        old_value = change[0]
        new_value = change[1]

        if is_nil_or_empty(old_value) && !is_nil_or_empty(new_value)
          change_text = "Added #{attr_name}: #{new_value}"
        elsif !is_nil_or_empty(old_value) && is_nil_or_empty(new_value)
          change_text = "Removed #{attr_name}"
        elsif !is_nil_or_empty(old_value) && !is_nil_or_empty(new_value) && old_value != new_value
          change_text = "Updated #{attr_name}: #{old_value} -> #{new_value}"
        else
          next
        end

        change_list += change_text + "\n"
      end
      return change_list
    end

    def is_nil_or_empty(value)
      if value.is_a? String
        return value.nil? || value.empty?
      end
      return value.nil?
    end
  end

  class_methods do

  end

end