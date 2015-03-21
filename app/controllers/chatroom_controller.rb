class ChatroomController < ApplicationController
  def index
    @latest_comments = Comment.limit(5).desc(:created_at).to_a
    redirect_to '/sessions/new' if session['username'].nil?
  end

  def comment
    translated_message = Dialect.find(session['dialect_slug']).translate(params['message'])
    Comment.create!(username: session['username'], dialect: session['dialect_slug'], message: translated_message)
    render json: {success: true}
  end
end
