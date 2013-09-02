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
	arr << "
 .----------------. 
| .--------------. |
| |    _______   | |
| |   /  ___  |  | |
| |  |  (__ \_|  | |
| |   '.___`-.   | |
| |  |`\____) |  | |
| |  |_______.'  | |
| |              | |
| '--------------' |
 '----------------' 
"
	arr << "
 .----------------. 
| .--------------. |
| |     ____     | |
| |   .'    `.   | |
| |  /  .--.  \  | |
| |  | |    | |  | |
| |  \  `--'  /  | |
| |   `.____.'   | |
| |              | |
| '--------------' |
 '----------------' 
"
	arr << "
 .----------------. 
| .--------------. |
| |     ______   | |
| |   .' ___  |  | |
| |  / .'   \_|  | |
| |  | |         | |
| |  \ `.___.'\  | |
| |   `._____.'  | |
| |              | |
| '--------------' |
 '----------------' 
 "
 	arr << "
 .----------------. 
| .--------------. |
| |  ________    | |
| | |_   ___ `.  | |
| |   | |   `. \ | |
| |   | |    | | | |
| |  _| |___.' / | |
| | |________.'  | |
| |              | |
| '--------------' |
 '----------------' 
 "
 	arr << "
 .----------------. 
| .--------------. |
| |  _________   | |
| | |_   ___  |  | |
| |   | |_  \_|  | |
| |   |  _|  _   | |
| |  _| |___/ |  | |
| | |_________|  | |
| |              | |
| '--------------' |
 '----------------' 
	"
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