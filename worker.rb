require 'redis'
require 'twitter'

uri = URI.parse(ENV["REDISTOGO_URL"])
redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
twitter = Twitter::Client.new

while true do
	if redis.smembers(:phrases).count <= 2
		tweets = twitter.search("#socoded -rt", :count => 50).results
		2.times { redis.sadd :phrases, tweets.sample.text }
	end
	sleep 0.5
end