class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :username
  field :message
  field :dialect

  validates :username, :message, :dialect, presence: true
end
