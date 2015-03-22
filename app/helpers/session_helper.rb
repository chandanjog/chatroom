require_relative '../../lib/erb_helper'

module SessionHelper
  def login_user
    session['username'] = params['username']
    session['dialect_slug'] = params['dialect_slug']
    filename = File.expand_path('../../views/chatroom/_active_users.html.erb', __FILE__)
    WebsocketRails[:active_usernames].trigger 'add', ::ErbHelper.load_erb(filename, {active_usernames: [session_username]})
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
