module SessionHelper
  def set_user_session_details
    session['username'] = params['username']
    session['dialect_slug'] = params['dialect_slug']
  end

  def clear_session
    session['username'] = nil
    session['dialect_slug'] = nil
  end

  def logged_in?
    !session['username'].nil?
  end

  def session_username
    session['username']
  end

  def session_dialect
    session['dialect_slug']
  end
end
