class User < ApplicationRecord
  include User::UserHelpers
  devise :database_authenticatable, :recoverable, :rememberable, :trackable
  enum status: { active: 0, deactivated: 1, deleted: 2, suspended: 3 }, _suffix: :status, _default: :active

  enum provider: { email: 0, phone: 1 }, _default: :phone
  enum status: { active: 0, deactivated: 1, deleted: 2, suspended: 3 }, _suffix: :status, _default: :active
  enum profile_status: { incomplete: 0, complete: 1 }, _suffix: :profile_status, _default: :incomplete
  enum gender: { male: 1, female: 2 }, _default: nil

  validates :name, presence: true
  validates :email, presence: true,
                    uniqueness: { conditions: -> { where(status: :active) }, if: :active_status? },
                    format: { with: EMAIL_REGEX, if: :active_status? }
  validates :password, presence: { if: :password_required? },
                       length: { within: PASSWORD_LENGTH, allow_blank: true },
                       format: { with: PASSWORD_REGEX, allow_blank: true, message: I18n.t("errors.invalid_password") }
  validates_uniqueness_of :phone_number, scope: :country_code, conditions: -> { where(status: :active) }, allow_blank: true, if: :active_status?

  has_many :devices, as: :authenticable, dependent: :destroy

  before_validation :delete_existing_unverified_users, if: -> { (phone_number_changed? || country_code_changed? || email_changed?) && active_status? }
  after_save :send_phone_verification_sms, if: -> {
                                             (saved_change_to_unconfirmed_country_code? || saved_change_to_unconfirmed_phone_number?) &&
                                               unconfirmed_country_code.present? && unconfirmed_phone_number.present? && active_status?
                                           }
end
