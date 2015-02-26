require 'singleton'
require 'eventmachine'
require 'minecraft_query/em/monitor'

class StatListener < MinecraftQuery::EM::Monitor
  include Singleton

  def initialize
    host = if Sinatra::Application.production?
             '127.0.0.1'
           else
             'mc.lemonspace.me'
           end
    client = MinecraftQuery::EM::Client.new host, timeout: 1
    super client
    start
  end

  def basic_stat
    client.last_basic_stat
  end

  def full_stat
    client.last_full_stat
  end
end
