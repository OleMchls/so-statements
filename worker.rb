require 'redis'
require 'twitter'

uri = URI.parse(ENV["REDISTOGO_URL"])
redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
queue = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
twitter = Twitter::Client.new

trap(:INT) { puts; exit }

begin
	redis.subscribe(:refil) do |on|
		on.message do |channel, message|
			tweets = twitter.search("#socoded -rt", :count => 50).results
			queue.sadd :phrases, tweets.sample.text
		end
	end
rescue Redis::BaseConnectionError => error
	puts "#{error}, retrying in 1s"
	sleep 1
	retry
end
