class Api::V1::Auth::SessionsController < BaseApiController
  include Api::V1::UsersHandler
  include Api::V1::Auth::DeviceManager
  skip_before_action :authorize_request, :authorize_action!, only: [:create, :verify_token_authenticity]
  before_action :set_user_model, only: [:create]
  before_action :format_phone_params, only: [:create]

  def create
    @user = Api::V1::Auth::AuthenticateUser.new(login_params, @user_class).user
    set_device(@user, device_params)
    @user.update_tracked_fields!(request)
    @user.save
    return response_json(status: :ok, data: { user: @user.as_json(options: detailed_view(is_owner: true)),
                                              device: @device.as_json(options: detailed_view),
                                              extra: { access_token: @user.get_token(@user.id, @user.class.name, @device.id) } })
  end

  def destroy
    @current_user_device&.destroy
    return response_json(message: I18n.t("messages.logged_out"), status: :ok)
  end

  def verify_token_authenticity
    begin
      if request.headers["Authorization"].present?
        user_object = Api::V1::Auth::AuthorizeApiRequest.new(request.headers).call
      end
    rescue => e
      raise ExceptionHandler::InvalidParameters.new(error: "invalid_credentials")
    end
  end

  def set_device_locale
    begin
      @current_user_device.update!(locale: I18n.locale)
      return render json: {}, status: :ok
    rescue => e
      raise ExceptionHandler::UnprocessableEntity.new(error: e.message)
    end
  end
end
