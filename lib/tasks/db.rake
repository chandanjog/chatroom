require_relative '../../lib/template'

namespace :db do
  desc 'delete all sessions'
  task delete_old_sessions: :environment do
    MongoidStore::Session.where(:updated_at.lt => Rails.configuration.session_timeout_in_minutes.minutes.ago).delete_all

    active_usernames = MongoidStore::Session.all.collect{|x| Marshal::load(x.data.data)['username']}
    WebsocketRails[:active_usernames].trigger 'refresh_all', Template.load('chatroom/_active_users.html.erb', :active_usernames, active_usernames)
  end
end
