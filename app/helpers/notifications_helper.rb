module NotificationsHelper
  def send_notification(registration_ids: [], options: set_notification_options)
    fcm = initialize_fcm
    response = fcm.send(registration_ids, options)
    log_fcm_request(response, registration_ids, options)
  end

  def set_notification_options(data: {}, notificaton: {}, priority: "high", additional_data: {})
    flutter_settings = { click_action: "FLUTTER_NOTIFICATION_CLICK" }
    options =
      {
        data: data.merge(flutter_settings),
        notification: notificaton,
        priority: priority,
      }.merge(additional_data)
  end

  def prepare_notification(registration_ids: [], notification_data: {}, data: {})
    notification_options = set_notification_options(data: data, notificaton: notification_data)
    send_notification(registration_ids: registration_ids, options: notification_options)
  end

  def send_notification_to_users(users: nil, notification: nil, data: nil)
    devices = Device.where(authenticable: users, logged_out: false)
    return unless devices.present?
    devices_locales = devices.pluck(:locale).uniq
    locales_to_send_to = devices_locales.map { |locale| AVAILABLE_LOCALES.include?(locale.to_sym) ? locale.to_sym : nil }.compact
    locales_to_send_to.each do |locale|
      locale_devices = devices.where(locale: locale)
      notification_data = {
        title: notification.title(locale: locale) || notification.title,
        body: notification.message(locale: locale) || notification.message,
      }
      registration_ids = locale_devices.pluck(:fcm_token).uniq
      prepare_notification(registration_ids: registration_ids, notification_data: notification_data, data: data) if registration_ids.any?
    end
  end

  private

  def initialize_fcm
    require "fcm"
    fcm = FCM.new(FCM_SERVER_KEY)
  end

  def log_fcm_request(response, registration_ids, options)
    logger = notification_logger
    logger.info("=" * 50)
    logger.info("registration_ids #{registration_ids.inspect}")
    logger.info(options.inspect)
    logger.info("server key #{FCM_SERVER_KEY}")
    logger.info("Response body #{response[:body].gsub(/[\"]/, "")}")
    logger.info("=" * 50)
  end

  def notification_logger
    logger ||= Logger.new("#{Rails.root}/log/notifications.log")
    return logger
  end
end
