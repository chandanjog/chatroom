class ChatroomController < ApplicationController
  def index
    redirect_to '/sessions/new' if session['username'].nil?
  end

  def comment
    translated_message = Dialect.find(session['dialect_slug']).translate(params['message'])
    Comment.create!(username: session['username'], dialect: session['dialect_slug'], message: translated_message)
    render json: {success: true}
  end
end
