require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

require 'rake'
Rake.application.init
Rake.application.load_rakefile

include Clockwork
delete_old_sessions_taskname = 'db:delete_old_sessions'

every(10.seconds, delete_old_sessions_taskname) do
  task = Rake::Task[delete_old_sessions_taskname]
  task.reenable
  task.invoke
end
