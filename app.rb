require 'sinatra'
require 'sinatra/contrib'
require 'oj'
require 'multi_json'

require_relative 'stat_listener'

configure do
  set :server, :thin
end

helpers do
  def listener
    StatListener.instance
  end
end

before do
  if listener.last_time
    last_modified listener.last_time
  end
end

get '/query/full_stat.json' do
  content_type :json
  if listener.full_stat
    json time: listener.last_time, full_stat: listener.full_stat
  else
    halt 503
  end
end

get '/query/basic_stat.json' do
  content_type :json
  if listener.basic_stat
    json time: listener.last_time, basic_stat: listener.basic_stat
  else
    halt 503
  end
end
