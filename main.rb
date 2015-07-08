#!/usr/bin/env ruby

require 'json'
require 'twitter'

output_file = './result'

property_file = './secret.property'

json = open(property_file) do |io|
  JSON.load(io)
end

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = json["YOUR_CONSUMER_KEY"]
  config.consumer_secret     = json["YOUR_CONSUMER_SECRET"]
  config.access_token        = json["YOUR_ACCESS_TOKEN"]
  config.access_token_secret = json["YOUR_ACCESS_SECRET"]
end

client.search("#sereading -rt", result_type: "recent", since_id: 618587741127753728).collect do |tweet|
  if m = tweet.text.match(/(\d{1,2}-\d\+\+)/)

    open(output_file, "a") {|f|
      f.puts "#{m[1]} #{tweet.id}"
    }
    puts m[1]
  end
end

stream = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = json["YOUR_CONSUMER_KEY"]
  config.consumer_secret     = json["YOUR_CONSUMER_SECRET"]
  config.access_token        = json["YOUR_ACCESS_TOKEN"]
  config.access_token_secret = json["YOUR_ACCESS_SECRET"]
end

stream.filter(track: "#sereading") do |object|
  if object.is_a?(Twitter::Tweet)
    puts object.inspect

    if m = object.text.gsub(" ","").match(/(\d{1,2}-\d\+\+)/)

      open(output_file, "a") {|f|
        f.puts "#{m[1]} #{object.id}"
      }
      puts m[1]
    end
  end
end
