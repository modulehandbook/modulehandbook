# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :trackable,
         :recoverable, :rememberable, :validatable, :confirmable

  belongs_to :faculty, optional: true

  # ROLES = %i[admin reader writer editor qa].freeze
  ROLES = %i[reader writer editor qa admin].freeze

  after_initialize :set_default_role, if: :new_record?

  before_destroy :check_for_versions

  def check_for_versions
    if versions_count > 0
      errors.add(:base, "User can't be Destroyed because there are Associated versions")
      throw :abort
    end
  end

  def format_time(at)
    return "" if (at.nil? || at == "")
    at.strftime("%d/%m/%y (%H:%M)")
  end

  def faculty_name
    @faculty_name ||= faculty ? faculty.name : "---"
  end

  def versions_count
    @versions_count ||=
      Course.versions_count_for_author(id) +
      Program.versions_count_for_author(id) +
      CourseProgram.versions_count_for_author(id)
  end

  def set_default_role
    self.role ||= :reader
  end

  after_create :send_admin_mail

  def send_admin_mail
    AdminMailer.new_user_waiting_for_approval(email).deliver
  end

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :not_approved
  end

  def self.send_reset_password_instructions(attributes = {})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.approved?
      recoverable.errors[:base] << I18n.t('devise.failure.not_approved')
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end
end
