# == Schema Information
#
# Table name: users
#
#  id                        :bigint           not null, primary key
#  avatar                    :string
#  confirmation_sent_at      :datetime
#  confirmation_token        :string
#  confirmed_at              :datetime
#  country_code              :string           default("")
#  current_sign_in_at        :datetime
#  current_sign_in_ip        :string
#  email                     :string           default(""), not null
#  enable_notifications      :boolean          default(FALSE)
#  encrypted_password        :string           default(""), not null
#  gender                    :integer
#  is_verified               :integer
#  last_sign_in_at           :datetime
#  last_sign_in_ip           :string
#  name                      :string
#  phone_number              :string           default("")
#  profile_status            :integer
#  reset_password_sent_at    :datetime
#  reset_password_token      :string
#  sign_in_count             :integer          default(0), not null
#  status                    :integer
#  unconfirmed_country_code  :string
#  unconfirmed_email         :string
#  unconfirmed_phone_number  :string
#  verification_code         :string
#  verification_code_sent_at :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token             (confirmation_token) UNIQUE
#  index_users_on_country_code_and_phone_number  (country_code,phone_number) UNIQUE
#  index_users_on_email                          (email) UNIQUE
#  index_users_on_email_and_status               (email,status) UNIQUE WHERE (status = 0)
#  index_users_on_reset_password_token           (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  include User::UserHelpers
  devise :database_authenticatable, :recoverable, :rememberable, :trackable
  enum status: { active: 0, deactivated: 1, deleted: 2, suspended: 3 }, _suffix: :status, _default: :active

  enum provider: { email: 0, phone: 1 }, _default: :phone
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
