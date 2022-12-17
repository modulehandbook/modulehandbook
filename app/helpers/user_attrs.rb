class UserAttrs

  READABLE = %i[
  id
  full_name
  email
  role
  faculty_id
  about
  approved
  unconfirmed_email].freeze

  ADMIN = %i[
  readable
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

  SECRET = %i[
  encrypted_password
  unlock_token
  confirmation_token
  reset_password_token].freeze

end
