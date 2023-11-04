class User::TokenVerification
  def initialize(user: nil, token: "", verification_country_code: "", verification_phone_number: "", verification_email: "", code_scope: "verification")
    @user = user
    @verification_country_code = verification_country_code
    @verification_phone_number = verification_phone_number
    @verification_email = verification_email
    @token = token
    @code_scope = code_scope
  end

  def verify_token
    puts "Start verification"
    verify_jwt
  end

  def verify_jwt
    decoded_token = JsonWebToken.decode(@token)
    @jwt_country_code = decoded_token[:country_code]
    @jwt_phone_number = decoded_token[:phone_number]
    @jwt_email = decoded_token[:email]
    @jwt_code_scope = decoded_token[:code_scope]
    puts "token phone number is #{@jwt_country_code}#{@jwt_phone_number} AND user phone number is #{@verification_country_code}#{@verification_phone_number}"
    raise ExceptionHandler::InvalidToken.new(error: "invalid_token") if falsy_token
    return true, {}
  end

  def falsy_token
    return @jwt_email.nil? || @jwt_email != @verification_email || @code_scope != @jwt_code_scope if @user.class.name == "AdminUser"
    return @jwt_country_code.nil? || @jwt_phone_number.nil? || @jwt_country_code != @verification_country_code ||
             @jwt_phone_number != @verification_phone_number || @code_scope != @jwt_code_scope
  end
end
