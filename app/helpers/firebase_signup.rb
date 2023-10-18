class FirebaseSignup
  def initialize
    @sdk_json = JSON.load File.open("firebase-adminsdk.json")
    @base_url = FIREBASE_URL
  end

  def create_custom_token(uid, is_premium_account)
    now_seconds = Time.now.to_i
    payload = { :iss => @sdk_json["client_email"],
                :sub => @sdk_json["client_email"],
                :aud => "https://identitytoolkit.googleapis.com/google.identity.identitytoolkit.v1.IdentityToolkit",
                :iat => now_seconds,
                :exp => now_seconds + (60 * 60), # Maximum expiration time is one hour
                :uid => uid }
    JWT.encode payload, OpenSSL::PKey::RSA.new(@sdk_json["private_key"]), "RS256"
  end

  def exchange_custom_token_with_id_token(custom_token) #To be able to update & delete users in firebase
    url = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=#{FIREBASE_API_KEY}"
    firebase_call = HTTParty.post(url, headers: { "Content-Type" => "application/json" },
                                       body: { "token" => custom_token }.to_json)
    return firebase_call.parsed_response["idToken"]
  end

  def change_email(user)
    custom_token = create_custom_token(uid, false)
    id_token = exchange_custom_token_with_id_token(custom_token)
    url = "https://identitytoolkit.googleapis.com/v1/accounts:update?key=#{FIREBASE_API_KEY}"
    firebase_call = HTTParty.post(url, headers: { "Content-Type" => "application/json" },
                                       body: { "idToken" => id_token, "email" => user.email }.to_json)
    return firebase_call
    raise(ExceptionHandler::InvalidUserData, firebase_call.parsed_response["error"]["message"]) unless firebase_call.response.code == "200"
  end

  def change_password(user)
    logger = fb_logger
    logger.info("Change Firebase User Password for user #{user.id}")
    custom_token = create_custom_token(user&.firebase_uid, false)
    id_token = exchange_custom_token_with_id_token(custom_token)
    url = "https://identitytoolkit.googleapis.com/v1/accounts:update?key=#{FIREBASE_API_KEY}"
    firebase_call = HTTParty.post(url, headers: { "Content-Type" => "application/json" },
                                       body: { "idToken" => id_token, "password" => user.password }.to_json)
    raise(ExceptionHandler::InvalidUserData, firebase_call.parsed_response["error"]["message"]) unless firebase_call.response.code == "200"
  end

  def create_user(user)
    firebase_email = user.email.present? ? user.email : "#{user.phone_number}@cadeau#{user.class.name}#{Rails.env}.com"
    url = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=#{FIREBASE_API_KEY}"
    body = {
      email: firebase_email,
      password: user.password || "password",
      emailVerified: true,
    }
    firebase_call = HTTParty.post(url, headers: { "Content-Type" => "application/json" },
                                       body: body.to_json)
    return firebase_call.parsed_response["localId"]
  end

  def delete_user(uid)
    logger = fb_logger
    logger.info("Delete Old Firebase User for uid #{uid}")
    custom_token = create_custom_token(uid, false)
    id_token = exchange_custom_token_with_id_token(custom_token)
    url = "https://identitytoolkit.googleapis.com/v1/accounts:delete?key=#{FIREBASE_API_KEY}"
    firebase_call = HTTParty.post(url, headers: { "Content-Type" => "application/json" },
                                       body: { "idToken" => id_token }.to_json)
    logger.info("Response code #{firebase_call.response.code}")
    logger.info("Response #{firebase_call.parsed_response}")
  end

  def fb_logger
    logger ||= ActiveSupport::Logger.new("#{Rails.root}/log/firebase_database.log")
  end
end
