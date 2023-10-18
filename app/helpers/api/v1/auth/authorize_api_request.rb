class Api::V1::Auth::AuthorizeApiRequest
  def initialize(headers = {})
    @headers = headers
  end

  # Service entry point - return valid user object
  def call
    {
      user: user,
      device: device
    }
  end

  private

  attr_reader :headers

  def user
    decoded_token = decoded_auth_token
    user_class = decoded_token[:authenticable_type]&.camelcase&.safe_constantize
    @user ||= user_class.find(decoded_token[:authenticable_id]) if decoded_token
    # handle user not found
  rescue ActiveRecord::RecordNotFound => e
    raise ExceptionHandler::InvalidToken.new(error: "invalid_token")
  end

  def device
    @device = Device.find(decoded_auth_token[:device]) if decoded_auth_token
    if @device.logged_out
      raise ExceptionHandler::InvalidToken.new(error: "unauthorized")
    end
    @device
  end

  # decode authentication token
  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  # check for token in `Authorization` header
  def http_auth_header
    return headers['Authorization'].split(' ').last if headers['Authorization'].present?
    raise ExceptionHandler::MissingToken.new(error: "missing_token")
  end
end
