class Api::V1::Auth::RegistrationController < BaseApiController
  include Api::V1::PhoneHandler
  include Api::V1::Auth::DeviceManager

  skip_before_action :authorize_request, :authorize_action!
  before_action :format_phone_params, :downcase_email_params

  def create
    ActiveRecord::Base.transaction do
      @user = User.new
      @user.assign_attributes(registration_params)
      @user.unconfirmed_email = @user.email
      @user.unconfirmed_country_code = @user.country_code
      @user.unconfirmed_phone_number = @user.phone_number
      @user.update_tracked_fields(request)
      set_device(@user, device_params)
      @user.save!
    end
    return response_json(status: :ok, data: { user: @user.reload.as_json(options: serializer_options(full_details: true, is_owner: true)),
                                             device: @device.as_json,
                                             extra: {
                           access_token: @user.get_token(@device.id),
                         } })
  end
end
