class UserAttrs

  COMPUTED = %i[
  faculty_name
  versions_count].freeze

  INDEX = %i[
  id
  full_name
  email
  role
  faculty_name
  approved
  readable
  versions_count].freeze

  EDITABLE = %i[
  id
  full_name
  email
  readable
  faculty
  about].freeze

  EDITABLE_ADMIN = %i[
  role
  approved].freeze

  READABLE = %i[
  id
  full_name
  email
  role
  faculty_name
  about
  approved
  unconfirmed_email].freeze

  ADMIN = %i[
  readable
  versions_count
  created_at
  updated_at
  sign_in_count
  failed_attempts
  current_sign_in_at
  last_sign_in_at
  current_sign_in_ip
  last_sign_in_ip
  confirmed_at
  confirmation_sent_at
  locked_at
  remember_created_at
  reset_password_sent_at].freeze

  SHOW = (READABLE + ADMIN).freeze

  OWN_READABLE_FIELDS = (READABLE + ADMIN).freeze

  SECRET = %i[
  encrypted_password
  unlock_token
  confirmation_token
  reset_password_token].freeze

end
