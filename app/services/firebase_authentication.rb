class FirebaseAuthentication
  include HTTParty

  def authenticate_firebase_token(token: "", provider: "phone")
    logger = fb_logger
    logger.info("Authenticate firebase token")
    logger.info("API KEY #{FCM_SERVER_KEY}")
    logger.info("Authenticate with token #{token}")
    url = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/getAccountInfo?key=#{FCM_SERVER_KEY}"
    firebase_verification_call = HTTParty.post(url, headers: { "Content-Type" => "application/json" }, body: { "idToken" => token }.to_json)
    logger.info("Response #{firebase_verification_call.response}")
    if firebase_verification_call.response.code == "200"
      logger.info("Success #{firebase_verification_call.parsed_response}")
      firebase_infos = firebase_verification_call.parsed_response
      profile = firebase_infos["users"].first
      return profile
    else
      logger.info("failed, with error #{firebase_verification_call.parsed_response}")
      response = firebase_verification_call.parsed_response
      message = response["error"]["message"]
      raise(ExceptionHandler::InvalidToken, message)
    end
  end

  def fb_logger
    logger ||= Logger.new("#{Rails.root}/log/fb_auth.log")
  end
end
