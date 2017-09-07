class FCMNotifier
  # this method actually creates and pushes the prepared notification
  def self.push(title, message, registration_id, data)
    n = Rpush::Gcm::Notification.new
    n.app = Rpush::Gcm::App.first
    n.registration_ids = [registration_id]
    n.notification = { 
      title: title,
      body: message,
    }
    n.data = data
    n.save!
  end
end
