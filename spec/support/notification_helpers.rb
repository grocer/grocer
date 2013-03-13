module NotificationHelpers
  def payload_hash(notification)
    JSON.parse(payload_bytes(notification), symbolize_names: true)
  end

  def payload_bytes(notification)
    notification.to_bytes[45..-1]
  end
end
