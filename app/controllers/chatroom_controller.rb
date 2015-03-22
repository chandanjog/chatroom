class ChatroomController < ApplicationController
  def index
    @latest_comments = Comment.limit(5).desc(:created_at).to_a
    redirect_to '/sessions/new' unless logged_in?
  end

  def comment
    translated_message = Dialect.find(session_dialect).translate(params['message'])
    comment = Comment.create!(username: session_username, dialect: session_dialect, message: translated_message)
    push_to_clients(comment)
    render json: {success: true}
  end

  private
  def push_to_clients(comment)
    filename = File.expand_path('../../views/chatroom/_comment.html.erb', __FILE__)
    binding_object = binding
    binding_object.local_variable_set(:comment, comment)
    erb = ERB.new(File.new(filename).read).result(binding_object)
    WebsocketRails[:posts].trigger 'new', erb
  end
end
