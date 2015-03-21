class ChatroomController < ApplicationController
  def index
    redirect_to '/sessions/new' if session['username'].nil?
  end

  def comment
  end
end
