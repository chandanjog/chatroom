require_relative '../../lib/template'

module SessionHelper
  def login_user
    session['username'] = params['username']
    session['dialect_slug'] = params['dialect_slug']
    WebsocketRails[:active_usernames].trigger 'add', ::Template.load('chatroom/_active_users.html.erb', :active_usernames, [session_username])
  end

  def logout_user
    WebsocketRails[:active_usernames].trigger 'remove', session_username
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

  def active_session_usernames
    MongoidStore::Session.all.collect{|x| Marshal::load(x.data.data)['username']}
  end
end
