require 'sinatra'
require 'redis'
require 'twitter'

configure do
	uri = URI.parse(ENV["REDISTOGO_URL"])
	set :redis, Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
	set :twitter, Twitter::Client.new
end

get '/' do
	text = settings.redis.spop :phrases
	return text unless text == nil
	['So Coded - So Code!', '<3 <3 <3', 'This conference is brought to you by @walski & @CodeStars & @seppsepp'].sample
end

post '/' do
	request.body.rewind  # in case someone already read it
	settings.redis.sadd :phrases, request.body.read
end