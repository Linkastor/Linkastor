workers Integer(1) #WARNING : current cron implementation doesn't support multiple workers : each worker starts a clock, if you start more than one worker you will have multiple cron running simultaneously
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  ActiveRecord::Base.establish_connection  
end