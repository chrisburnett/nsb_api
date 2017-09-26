class FCMNotifier

  def self.push(*args)
    if Rails.env.production? then fcm_push(*args)
    else
      debug_log(*args)
    end
  end

  def self.debug_log(title, message, registration_id, data)
    puts "[NOTIFICATION] #{title}: #{message}"
  end
  
  # this method actually creates and pushes the prepared notification
  def self.fcm_push(title, message, registration_id, data)
    n = Rpush::Gcm::Notification.new
    n.app = Rpush::Gcm::App.first
    n.registration_ids = [registration_id]
    n.notification = { 
      title: title,
      body: message,
    }
    n.data = data
    n.save!
    puts "[NOTIFICATION] #{title}: #{message}"
  end
end
