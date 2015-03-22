require_relative '../../lib/erb_helper'

namespace :db do
  desc 'delete all sessions'
  task delete_old_sessions: :environment do
    MongoidStore::Session.where(:updated_at.lt => Rails.configuration.session_timeout_in_minutes.minutes.ago).delete_all

    filename = File.expand_path('../../../app/views/chatroom/_active_users.html.erb', __FILE__)
    active_usernames = MongoidStore::Session.all.collect{|x| Marshal::load(x.data.data)['username']}
    WebsocketRails[:active_usernames].trigger 'refresh_all', ErbHelper.load_erb(filename, {active_usernames: active_usernames})
  end
end
