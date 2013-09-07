require 'redis'
require 'twitter'
require 'htmlentities'

uri = URI.parse(ENV["REDISTOGO_URL"])
redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
queue = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
twitter = Twitter::Client.new

trap(:INT) { puts; exit }

begin
	redis.subscribe(:refil) do |on|
		on.message do |channel, message|
			tweet = twitter.search("#socoded -rt", :count => 50).results.sample
			p tweet
			queue.sadd :phrases, "#{HTMLEntities.new.decode(tweet.text)}\n\ - #{tweet.user.name} (@#{tweet.user.screen_name})"
		end
	end
rescue Redis::BaseConnectionError => error
	puts "#{error}, retrying in 1s"
	sleep 1
	retry
end
