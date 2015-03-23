class ChatroomController < ApplicationController
  MESSAGE_TOO_BIG_ERROR_MESSAGE = "Cannot post message bigger than #{Comment::MAX_MESSAGE_CHARS} characters."

  def index
    @active_usernames = active_session_usernames
    @latest_comments = Comment.limit(5).desc(:created_at).to_a
    return redirect_to '/sessions/new' unless logged_in?
    render layout: 'with_active_users_sidebar'
  end

  def comment
    return render json: {success: false, error_message: MESSAGE_TOO_BIG_ERROR_MESSAGE} unless Comment.valid_character_limit?(params['message'])
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
