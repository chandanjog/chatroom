class Websocket
  def self.trigger(channel_name, action, data)
    Fiber.new { WebsocketRails[channel_name].trigger action, data }.resume
  end
end
