class User::PhoneVerificationService
  def initialize(user: nil, service: "")
      @user = user
      @service = service
  end

  def verify_phone_number(token)
      country_code_to_verify, phone_number_to_verify = @user.phone_number_to_verify
      is_verified, extra_data = User::TokenVerification.new(
          user: @user,
          token: token,
          verification_country_code: country_code_to_verify,
          verification_phone_number: phone_number_to_verify,
          code_scope: "verification"
      ).verify_token
      @user.assign_attributes({is_verified: is_verified}.merge(verification_data).merge(extra_data))
      return @user
  end

  def verification_data
      to_set = {
          verification_code_sent_at: nil,
          verification_code: nil
      }
      unless @user.country_code.blank? && @user.phone_number.blank?
        country_code_to_verify, phone_number_to_verify = @user.phone_number_to_verify
        to_set = to_set.merge({
          country_code: @user.unconfirmed_country_code,
          phone_number: @user.unconfirmed_phone_number,
          unconfirmed_country_code: nil,
          unconfirmed_phone_number: nil
        }) if (country_code_to_verify != @user.country_code) || (phone_number_to_verify != @user.phone_number)
      end
      return to_set
  end
end
