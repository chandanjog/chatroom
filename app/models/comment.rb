class Comment
  MAX_MESSAGE_CHARS = 1000
  include Mongoid::Document
  include Mongoid::Timestamps

  field :username
  field :message
  field :dialect

  validates :username, :message, :dialect, presence: true

  def self.valid_character_limit?(message)
    message.size <= MAX_MESSAGE_CHARS
  end
end
