class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :username
  field :message
  field :dialect

  validates :username, :message, :dialect, presence: true

  after_save do
    latest_post = self
    WebsocketRails[:posts].trigger 'new', latest_post
  end
end
