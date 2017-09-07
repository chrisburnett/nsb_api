class FCMNotifier

  def push(title, message, registration_id, data)
    if Rails.env.production? then fcm_push(*args)
    else debug_log(*args) end
  end

  def debug_log(title, message, registration_id, data)
    binding.pry
    puts "[NOTIFICATION] #{title}: #{message}"
  end
  
  # this method actually creates and pushes the prepared notification
  def fcm_push(title, message, registration_id, data)
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
