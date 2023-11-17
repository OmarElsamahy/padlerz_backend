module Api::V1::Auth::DeviceManager
  def set_device(user, device_params)
    raise ExceptionHandler::InvalidParameters.new(error: "missing_params") unless device_params.present?
    @device = user.devices.find_or_initialize_by(device_type: params[:device_type], fcm_token: device_params[:fcm_token])
    @device.assign_attributes(device_params)
    @device.locale = I18n.locale
    @device.logged_out = false
    @device.save!
    return @device
  end

  def update_device_locale
    if @current_user_device&.id.present? && @current_user_device.locale != I18n.locale
      @current_user_device.locale = I18n.locale
      @current_user_device.save
    end
  end

  def device_params
    params.require(:device).permit(:fcm_token, :device_type)
  end
end
