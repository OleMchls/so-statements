require 'sinatra'
require 'redis'

configure do
	uri = URI.parse(ENV["REDISTOGO_URL"])
	set :redis, Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

get '/' do
	settings.redis.spop :phrases
end

post '/' do
	request.body.rewind  # in case someone already read it
	settings.redis.sadd :phrases, request.body.read
end