require 'clockwork'
require 'rake'

module Clockwork
  handler do |job|
    puts "Running #{job}"
    if job == 'delete_old_sessions'
      Rake.application.init
      Rake.application.load_rakefile
      Rake::Task['db:delete_old_sessions'].reenable
      Rake::Task['db:delete_old_sessions'].invoke
    end
  end

  every(10.seconds, 'delete_old_sessions')
end
