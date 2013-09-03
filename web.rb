require 'sinatra'
require 'redis'
require 'twitter'

configure do
	uri = URI.parse(ENV["REDISTOGO_URL"])
	set :redis, Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
	set :twitter, Twitter::Client.new
end

def random_string()
	arr = Array.new
	arr << 'So Coded - So Code!'
	arr << '<3 <3 <3'
	arr << 'This conference is brought to you by @walski & @CodeStars & @seppsepp'
	arr << 'Julia und Elena sind so clever, und sooo toll und so intelligent und überhaupt und sowieso <3'
	arr << 'O - Stone'
	arr << 'Y - Sciccors'
	arr << '+ - Paper'
	arr.sample
end

get '/' do
	text = settings.redis.spop :phrases
	return text unless text == nil
	random_string
end

post '/' do
	request.body.rewind  # in case someone already read it
	settings.redis.sadd :phrases, request.body.read
end