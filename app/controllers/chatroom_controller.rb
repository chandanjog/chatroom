class ChatroomController < ApplicationController
  def index
    @active_usernames = active_session_usernames
    @latest_comments = Comment.limit(5).desc(:created_at).to_a
    return redirect_to '/sessions/new' unless logged_in?
    render layout: 'with_active_users_sidebar'
  end

  def comment
    translated_message = Dialect.find(session_dialect).translate(params['message'])
    comment = Comment.create!(username: session_username, dialect: session_dialect, message: translated_message)
    push_to_clients(comment)
    render json: {success: true}
  end

  private
  def push_to_clients(comment)
    Websocket.trigger(:posts, 'new', Template.load('chatroom/_comment.html.erb', :comment, comment))
  end
end
