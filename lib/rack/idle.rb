module Rack # :nodoc:
end

# Rack::Idle is a Rack middleware that will automatically shutdown idle Rack
# servers.
# 
# Just add the following to your config.ru:
#   require "rack/idle"
#   
#   use Rack::Idle
#   
#   ...
# 
# and once no requests have been received for 10 minutes +exit+ will be called
# to shutdown the server.
# 
# The timeout can be customised like so:
#   use Rack::Idle, :timeout => 300 # 300 seconds == 5 minutes
# 
# Additionally a file can be monitored, and the server shutdown if the timestamp
# is updated:
#   use Rack::Idle, :watch => "restart.txt" # touch restart.txt to shutdown
# 
class Rack::Idle
  
  # :call-seq: Idle.new(app, [options]) -> idle
  # 
  # Create a new idle middleware instance, wrapping +app+.
  # 
  # Available options:
  # [timeout] Amount of time (in seconds) to wait after a request before calling
  #           +exit+ to shutdown the server
  # 
  # [watch]   Path to a file (relative to the working directory) to monitor,
  #           shutting down the server if the last modified date is updated.
  # 
  def initialize(app, opts={})
    @app = app
    
    self.class.last_activity = Time.now
    timeout = (opts[:timeout] || 600)
    
    watch = opts[:watch]
    if watch && File.exist?(watch)
      watch_mtime = File.mtime(watch)
    elsif watch
      watch_mtime = Time.now
    end
    
    Thread.new do
      loop do
        exit if Time.now - self.class.last_activity > timeout
        exit if watch && File.exist?(watch) && File.mtime(watch) > watch_mtime
        sleep 1
      end
    end.abort_on_exception = true
  end
  
  class << self
    attr_accessor :last_activity # :nodoc:
  end
  
  # :call-seq: idle.call(env) -> status_headers_body
  # 
  # Proxied to the +app+ supplied to ::new.
  # 
  def call(env)
    self.class.last_activity = Time.now
    @app.call(env)
  end
  
end
