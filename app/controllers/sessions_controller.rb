class SessionsController < ApplicationController
  MISSING_USERNAME_OR_DIALECT_ERROR_MSG = 'Username or Dialect cannot be empty'
  DIALECT_OPTIONS = [['Pirate', 'pirate'], ['Yoda', 'yoda'], ['Valley Girl', 'valley-girl']]

  def create
    if params['username'].empty? || params['dialect_slug'].empty?
      @dialect_options = DIALECT_OPTIONS
      @error_message = MISSING_USERNAME_OR_DIALECT_ERROR_MSG
      return render '/sessions/new', layout: 'without_sidebar'
    end
    session['username'] = params['username']
    session['dialect_slug'] = params['dialect_slug']
    redirect_to '/chatroom/index'
  end

  def new
    @dialect_options = DIALECT_OPTIONS
    render layout: 'without_sidebar'
  end
end
