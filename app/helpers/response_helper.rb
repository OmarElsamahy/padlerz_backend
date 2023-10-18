module ResponseHelper
  def response_json(message: I18n.t("success"), status: :ok, data: {}, extra: {})
    json_response = { message: message, data: data }
    extra = extra.merge(@pagination_info) if @pagination_info.present?
    json_response = json_response.merge(extra: extra) if extra.present?
    render json: json_response, status: status
  end

  def response_json_error(error: "", message: "", status: :unprocessable_entity, data: {})
    response = { error: error, message: message }
    response[:data] = data if data.present?
    render json: response, status: status
  end

  def response_record_error(record)
    render json: { error: record.errors.first, message: record.errors.full_messages.first }, status: :unprocessable_entity
  end

  def current_user_view
    { params: { current_user: @current_user, time_zone: @time_zone,
               current_city: @current_city, current_fulfillment_center_city: @current_fulfillment_center_city&.id } }
  end

  def detailed_view(is_owner: false)
    { params: { is_owner: is_owner, full_details: true, current_user: @current_user, time_zone: @time_zone,
               current_city: @current_city, current_fulfillment_center_city: @current_fulfillment_center_city&.id } }
  end

  def basic_user_view(is_owner: false)
    { params: { is_owner: is_owner, full_details: false, current_user: @current_user, time_zone: @time_zone,
               current_city: @current_city, current_fulfillment_center_city: @current_fulfillment_center_city&.id } }
  end

  def detailed_product_view(product_id: 1, option_values: 1)
    { params: { product_id: product_id, option_values: option_values } }
  end

  def basic_view(is_owner: false)
    { params: { time_zone: @time_zone, current_city: @current_city } }
  end
end
