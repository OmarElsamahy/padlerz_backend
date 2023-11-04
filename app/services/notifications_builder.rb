class NotificationsBuilder
  include NotificationsHelper

  def initialize(notification_type: "", message: "", receiver_type: "", receivers: [], data: nil, data_id: "")
    @notification_type = notification_type.to_sym
    @message = message
    @receiver_type = receiver_type
    @receivers = receivers
    @data = data
    @data_id = @data_id
  end

  def perform
    title = I18n.t("new_message")
    data = { type: @notification_type, data: @data, data_id: @data_id }
    notification = Notification.new(
      title: title,
      message: @message,
      notification_type: @notification_type,
      data: @data,
      data_id: @data_id,
      need_action: true,
    )
    notification.save!
    case @receiver_type
    when "Customer"
      notification.customers << @receivers
      notifiable_users = notification.customers.where(enable_push: true)
    when "Driver"
      notification.drivers << @receivers
      notifiable_users = notification.drivers.where(enable_push: true)
    when "AdminUser"
      notification.admin_users << @receivers
      notifiable_users = notification.admin_users
    when "Store"
      notification.stores << @receivers
      notifiable_users = notification.stores
    end

    puts data
    send_notification_to_users(users: notifiable_users, notification: notification, data: data)
  end
end
