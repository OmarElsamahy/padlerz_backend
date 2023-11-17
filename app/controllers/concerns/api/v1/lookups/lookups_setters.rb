module Api::V1::Lookups::LookupsSetters
  extend ActiveSupport::Concern

  private

  def set_delivery_time
    @delivery_time = DeliveryTime.find(params[:delivery_time_id])
  end

  def set_current_featured_banner
    @featured_banner = FeaturedBanner.find_by(id: params[:featured_banner_id].to_i)
    raise ExceptionHandler::InvalidParameters.new(error: "invalid_params") unless @featured_banner.present?
  end

  def set_current_occasion_type
    @occasion_type = OccasionType.find_by(id: params[:occasion_type_id].to_i)
    raise ExceptionHandler::InvalidParameters.new(error: "invalid_params") unless @occasion_type.present?
  end

  def set_current_order_declination_reason
    @order_declination_reason = OrderDeclinationReason.find(params[:order_declination_reason_id])
  end

  def set_current_system_configuration
    @system_configuration = SystemConfiguration.find(params[:system_configuration_id])
  end

  def set_current_customer
    @customer = Customer.find(params[:customer_id])
  end

  def set_current_notification
    @notification = Notification.find(params[:notification_id])
    @notification_user = NotificationUser.find_by(notifiable_id: @current_user.id,
                                                  notifiable_type: @current_user.class.name,
                                                  notification_id: @notification.id)
  end

  def set_current_occasion
    @occasion = Occasion.not_deleted_status.find_by(id: params[:occasion_id].to_i)
    raise ExceptionHandler::InvalidParameters.new(error: "invalid_params") unless @occasion.present?
  end

  def set_current_option_value
    @option_value = OptionValue.find(params[:option_value_id])
  end

  def set_current_option_type
    @option_type = OptionType.find(params[:option_type_id])
  end

  def set_current_order_complaint_reason
    @order_complaint_reason = OrderComplaintReason.find(params[:order_complaint_reason_id])
  end

  def set_current_route_complaint_reason
    @route_complaint_reason = RouteComplaintReason.find(params[:route_complaint_reason_id])
  end

  def set_current_order_complaint
    @order_complaint = OrderComplaint.find(params[:order_complaint_id])
  end

  def set_current_route_complaint
    @route_complaint = RouteComplaint.find(params[:route_complaint_id])
  end

  def set_current_country
    @country = Country.find_by(id: params[:country_id].to_i)
    raise ExceptionHandler::InvalidParameters.new(error: "invalid_params") unless @country.present?
  end

  def set_current_tag
    @tag = Tag.find_by(id: params[:tag_id].to_i)
    raise ExceptionHandler::InvalidParameters.new(error: "invalid_params") unless @tag.present?
  end

  def set_current_zone
    @zone = Zone.find(params[:zone_id].to_i)
  end

  def set_current_between_zones_fee
    @between_zones_fee = BetweenZonesFee.find(params[:between_zones_fee_id].to_i)
  end

  def set_current_store
    @store = Store.find_by(id: params[:store_id].to_i)
    raise ExceptionHandler::InvalidParameters.new(error: "invalid_params") unless @store.present?
  end

  def set_current_suggested_wrapper
    @suggested_wrapper = SuggestedWrapper.find_by(id: params[:suggested_wrapper_id].to_i)
    raise ExceptionHandler::InvalidParameters.new(error: "invalid_params") unless @suggested_wrapper.present?
  end

  def set_current_product
    @product = Product.find_by(id: params[:product_id].to_i)
    raise ExceptionHandler::InvalidParameters.new(error: "invalid_params") unless @product.present?
  end

  def set_current_wishlist
    @wishlist = Wishlist.find_by(id: params[:wishlist_id].to_i)
    raise ExceptionHandler::InvalidParameters.new(error: "invalid_params") unless @wishlist.present?
  end

  def set_current_system_notification
    @notification = Notification.system_nt.find(params[:notification_id])
  end

  def set_current_cart
    authorize_request unless @current_user.present?
    @cart = @current_user.pending_cart
    @cart = @current_user.create_pending_cart if @cart.nil?
    @cart.validation_city_id = @current_city
    return if @cart.cart_items.empty?
    unavailable_in_city = false
    @cart.variants.each do |variant|
      unavailable_in_city = true unless variant.google_city_ids.include?(@current_fulfillment_center_city&.id)
    end
    raise ExceptionHandler::InvalidParameters.new(error: "change_city_back") if unavailable_in_city
  end

  def set_current_cart_item
    @cart_item = CartItem.find_by(id: params[:cart_item_id].to_i)
    raise ExceptionHandler::InvalidParameters.new(error: "invalid_params") unless @cart_item.present?
    @cart_item.validation_city_id = @current_city
  end

  def set_current_gift_card
    @gift_card = GiftCard.find_by(id: params[:gift_card_id].to_i)
    raise ExceptionHandler::InvalidParameters.new(error: "invalid_params") unless @gift_card.present?
  end

  def set_current_wrapper
    @current_wrapper = Wrapper.find_by(id: params[:wrapper_id].to_i)
    raise ExceptionHandler::InvalidParameters.new(error: "invalid_params") unless @current_wrapper.present?
  end

  def set_current_wrap
    @wrap = Wrap.find(params[:wrap_id])
  end

  def set_current_wrap_extra
    @wrap_extra = WrapExtra.find(params[:wrap_extra_id])
  end

  def set_current_shape
    @shape = Shape.find(params[:shape_id])
  end

  def set_current_color
    @color = Color.find(params[:color_id])
  end

  def set_current_ribbon_color
    @ribbon_color = RibbonColor.find(params[:ribbon_color_id])
  end

  def set_current_wrap_variant
    @wrap_variant = WrapVariant.find(params[:wrap_variant_id])
  end

  def set_current_order
    @order = Order.find_by(id: params[:order_id].to_i)
    raise ExceptionHandler::InvalidParameters.new(error: "invalid_params") unless @order.present?
  end

  def set_current_order_request
    @order_request = Order.find_by(id: params[:order_request_id].to_i)
    raise ExceptionHandler::InvalidParameters.new(error: "invalid_params") unless @order_request.present?
  end

  def set_current_route
    @route = Route.find_by(id: params[:route_id].to_i)
    raise ExceptionHandler::InvalidParameters.new(error: "invalid_params") unless @route.present?
  end

  def set_current_driver
    @driver = Driver.find(params[:driver_id])
  end

  def set_current_route_applied_driver
    @route_applied_driver = RouteAppliedDriver.find_by(id: params[:route_applied_driver_id].to_i)
    raise ExceptionHandler::InvalidParameters.new(error: "invalid_params") unless @route_applied_driver.present?
  end

  def set_current_wallet
    @wallet = Wallet.find_or_create_by(user_id: @current_user.id, user_type: @current_user.class.name)
  end

  def set_current_city_to_show
    @current_city = GoogleCity.find(params[:city_id].to_i)
    raise ExceptionHandler::InvalidParameters.new(error: "invalid_params") unless @current_city.present?
  end

  def set_current_wallet_transaction
    @wallet_transaction = @wallet.wallet_transactions.find_by(id: params[:wallet_transaction_id].to_i)
    raise ExceptionHandler::InvalidParameters.new(error: "invalid_params") unless @wallet_transaction.present?
  end

  def set_current_category
    @current_category = Category.find(params[:category_id])
  end

  def set_current_google_city_store
    @current_city_store = GoogleCitiesStore.find_by(store_id: params[:store_id], google_city_id: params[:google_city_id])
    raise ExceptionHandler::InvalidParameters.new(error: "invalid_params") unless @current_city_store.present?
  end

  def set_current_google_city_variant
    @current_city_variant = GoogleCitiesVariant.find_by(variant_id: params[:variant_id], google_city_id: params[:google_city_id])
    raise ExceptionHandler::InvalidParameters.new(error: "invalid_params") unless @current_city_variant.present?
  end
end
