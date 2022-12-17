module UsersHelper
  FIELD_TYPE = User.columns_hash.transform_keys(&:to_sym).transform_values{ |v| v.type}
  FIELD_TYPE[:faculty_name] = :string
  FIELD_TYPE[:versions_count] = :integer
  def field_type(field_name)
    FIELD_TYPE[field_name.to_sym]
  end

end
