class Api::V1::Auth::AuthenticateUser
  def initialize(parameters, user_class = nil)
    puts "Parameters in service are #{parameters}"
    @phone_number = parameters[:phone_number]
    @country_code = parameters[:country_code]
    @password = parameters[:password]
    @email = parameters[:email]
    @user_class = user_class
  end

  # Service entry point
  def call
    {
      user: user,
    }
  end

  def user
    if (@user_class == AdminUser) && @email.present?
      user = AdminUser.active.find_by(email: @email)
      user = Store.active.find_by(email: @email) unless user
    else
      user = @user_class.active.find_by(country_code: country_code, phone_number: phone_number)
    end
    raise ExceptionHandler::AccountNotFound.new(error: "account_not_found") if user.nil? || !user.is_verified? || user.deleted_status?
    raise ExceptionHandler::AuthenticationError.new(error: "invalid_credentials") unless user&.valid_password?(@password)
    return user
  end

  def user_auth_failure(given_user)
    given_user.nil? || !given_user.is_verified? || given_user.deleted_status? || !given_user&.valid_password?(@password)
  end

  private

  attr_reader :email, :password, :country_code, :phone_number
end
