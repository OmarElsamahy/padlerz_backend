class GoogleAuthentication
  include HTTParty

  def get_google_profile(access_token: nil)
    url = URI("https://oauth2.googleapis.com/tokeninfo?id_token=#{access_token}")
    logger = gm_logger
    logger.info("Authentication Google")
    logger.info("Access Token #{access_token}")

    google_call = HTTParty.get(url)
    logger.info("Response #{google_call.response}")

    if google_call.response.code == "200"
      logger.info("Success")
      firebase_infos = google_call.parsed_response
    else
      logger.info("Failed, with error #{google_call.parsed_response}")
      response = google_call.parsed_response
      message = response["error"]["message"]
      raise(ExceptionHandler::AuthenticationError, message)
    end
  end

  def gm_logger
    logger ||= ActiveSupport::Logger.new("#{Rails.root}/log/google_auth.log")
  end
end
