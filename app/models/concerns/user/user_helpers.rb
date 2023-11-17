module User::UserHelpers
  extend ActiveSupport::Concern
  # require "firebase_signup"

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def get_token(authenticable_id, authenticable_type, device_id)
    payload = {}
    payload[:authenticable_id] = authenticable_id
    payload[:authenticable_type] = authenticable_type
    payload[:device] = device_id
    payload[:created_at] = DateTime.now.to_i
    JsonWebToken.encode(payload)
  end

  def set_phone_number
    if self.phone_number.present? && self.country_code.present?
      phone_obj = PhoneFormatter::format_phone(self.phone_number, self.country_code)
      unless phone_obj.nil?
        self.country_code = phone_obj[:country_code]
        self.phone_number = phone_obj[:phone]
      end
    end

    if self.unconfirmed_phone_number.present? && self.unconfirmed_country_code.present?
      phone_obj = PhoneFormatter::format_phone(self.unconfirmed_phone_number, self.unconfirmed_country_code)
      unless phone_obj.nil?
        self.unconfirmed_country_code = phone_obj[:country_code]
        self.unconfirmed_phone_number = phone_obj[:phone]
      end
    end
  end

  def full_phone
    self.country_code&.+ self.phone_number
  end

  def delete_existing_unverified_users #before validation
    puts "DELETING EXISTING UNVERIFIED APP USERS"
    if (self.phone_number.present? && self.country_code.present?)
      self.class.active.unverified.all_except(self)
        .where("(country_code = :country_code AND phone_number = :phone_number)",
               country_code: self.country_code, phone_number: self.phone_number).destroy_all
      self.class.verified.all_except(self).where(unconfirmed_country_code: self.country_code, unconfirmed_phone_number: self.set_phone_number)
        .update_all(unconfirmed_country_code: nil, unconfirmed_phone_number: nil)
    end
  end

  def reactivate
    self.update_column(:status, :active)
  end

  def generate_code(code_size: 6)
    code = nil
    code = code_size.times.map { rand(10) }.join.to_s while code.nil? || self.class.where("verification_code = :code OR  reset_password_token = :code", code: code).present?
    return code
  end

  def generate_verification_code
    code = self.generate_code(code_size: 6)
    self.verification_code = code
    self.verification_code_sent_at = DateTime.now + 15.seconds
  end

  def generate_reset_password_code
    code = self.generate_code(code_size: 6)
    self.reset_password_token = code
    self.reset_password_sent_at = DateTime.now + 15.seconds
  end

  def generate_email_token
    token = nil
    token = SecureRandom.urlsafe_base64.to_s while token.nil? || self.class.where("verification_email_token = :token", token: token).present?
    return token
  end

  def generate_verification_email_token
    token = self.generate_email_token
    self.verification_email_token = token
    self.is_email_verified = false
    self.save!
  end

  def deactivate_user
    self.update!(status: "deactivated")
  end

  def set_user_to_deleted
    self.status = "deleted"
    self.save!
  end

  def update_based_on_status
    if self.deactivated_status? || self.deleted_status?
      self.devices.destroy_all
    end
  end

  def can_handle(notification_type: "system")
    return self.enable_push
  end

  def email_to_verify
    return self.unconfirmed_email if self.unconfirmed_email.present?
    self.email
  end

  def phone_number_to_verify
    return self.unconfirmed_country_code, self.unconfirmed_phone_number if self.unconfirmed_country_code.present? && self.unconfirmed_phone_number.present?
    return self.country_code, self.phone_number
  end

  def send_verification_sms
    generate_verification_code
    ##to do add sms_service
    self.save
  end

  def send_reset_password_sms
    generate_reset_password_code
    ##to do add sms_service
    self.save
  end

  def send_reset_password_email
    generate_reset_password_code
    self.save
    # UserMailer.reset_password_confirmation(self).deliver
  end

  def send_verification_email
    generate_verification_email_token
    UserMailer.email_confirmation(self).deliver
  end

  def activate_email
    self.is_email_verified = true
    self.verification_email_token = nil
    save!
  end

  def social_provider?
    !(self.email_provider? || self.phone_provider?)
  end

  def create_firebase_user
    self.firebase_uid = FirebaseSignup.new.create_user(self)
    self.save!
  end

  def get_firebase_token
    return nil unless self.firebase_uid.present?
    FirebaseSignup.new.create_custom_token(self.firebase_uid, true)
  end

  def update_firebase_user
    FirebaseSignup.new.change_password(self)
  end

  def check_profile_status
    if self.is_verified? && self.name.present? && !self.phone_number.empty? && self.national_id.present? && self.country_id.present? && self.city_id.present? && !self.country_code.empty? && self.birthdate.present? && self.avatar.present?
      self.profile_status = "pending_approval"
    end
  end

  module ClassMethods
    def get_from_phone(phone: "")
      self.class.active.where(
        "CONCAT(users.country_code, users.phone_number) = :phone_number OR users.phone_number = :phone_number OR
            CONCAT(users.unconfirmed_country_code, users.unconfirmed_phone) = :phone_number OR users.unconfirmed_phone = :phone_number",
        phone_number: phone.to_s,
      ).first
    end
  end
end
