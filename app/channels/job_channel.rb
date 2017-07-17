class JobChannel < ApplicationCable::Channel
  def subscribed
    puts "SUBSCRIPTION ---------------------------"
    stream_from 'jobs'
  end
end
