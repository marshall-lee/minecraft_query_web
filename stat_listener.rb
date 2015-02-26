require 'singleton'
require 'eventmachine'
require 'minecraft_query/em/monitor'

require_relative 'global_faye_client'

class StatListener < MinecraftQuery::EM::Monitor
  include Singleton

  def initialize
    host = Sinatra::Application.settings.query_host
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

  def on_success(result)
    super
    case result
    when MinecraftQuery::Protocol::BasicStatResponse
      GlobalFayeClient.instance.publish '/basic_stat', result.to_hash
    when MinecraftQuery::Protocol::FullStatResponse
      GlobalFayeClient.instance.publish '/full_stat', result.to_hash
    end
  end
end
