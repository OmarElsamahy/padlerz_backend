module Api::V1::PhoneHandler
  extend ActiveSupport::Concern

  def format_phone_params
    return if @user_class == AdminUser
    if params[:user][:phone_number] && params[:user][:country_code]
      phone_obj = PhoneFormatter::format_phone(params[:user][:phone_number], params[:user][:country_code])
      params[:user][:country_code] = phone_obj[:country_code]
      params[:user][:phone_number] = phone_obj[:phone]
    end
  end
end
