class User::ResetPasswordService
  def initialize(user: nil)
    @user = user
  end

  def reset_password(password: nil, password_confirmation: nil, token: nil, verify: true)
    verify_reset_password(token) if verify
    raise ExceptionHandler::InvalidParameters.new(error: "invalid_password") unless @user.reset_password(password, password_confirmation)
    return @user
  end

  def verify_reset_password(token)
    email_to_verify = @user.email_to_verify
    country_code_to_verify, phone_number_to_verify = @user.phone_number_to_verify
    is_verified, extra_data = User::TokenVerification.new(
      user: @user,
      token: token,
      verification_email: email_to_verify,
      verification_country_code: country_code_to_verify,
      verification_phone_number: phone_number_to_verify,
      code_scope: "reset_password",
    ).verify_token
    @user.assign_attributes({}.merge(reset_password_data).merge(extra_data))
  end

  def reset_password_data
    {
      reset_password_token: nil,
      reset_password_sent_at: nil,
    }
  end
end
