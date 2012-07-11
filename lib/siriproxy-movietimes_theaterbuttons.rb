require 'cora'
require 'siri_objects'
require 'nokogiri'
require 'open-uri'

class SiriProxy::Plugin::MovieTimes < SiriProxy::Plugin
def initialize(config)
end
filter "StartRequest", direction: :from_iphone do |object|
   puts "[Info - Button Information] #{object["properties"]["utterance"]}"
   say "#{object["properties"]["utterance"]}"
   object = false
   request_completed 
end
filter "SetRequestOrigin", direction: :from_iphone do |object|
  puts "[Info - User Location] lat: #{object["properties"]["latitude"]}, long: #{object["properties"]["longitude"]}"
end
def createButton(theater,more)
    utterance = "#{theater}"
    startRequest = SiriStartRequest.new(utterance,true,false)
    sendCommand = SiriSendCommands.new
    sendCommand.commands << startRequest
    button = SiriButton.new(text)
    button.commands << sendCommand
    return button
end
   listen_for /Movie times/i do
      say "Getting movie times for #{location.city}, #{location.state}"
      movieShowTimes = GoogleMovies47::Crawler.new({ :city => '#{location.city}', :state => '#{location.state}' })
      theaters = movieShowTimes.theaters
      buttons = SiriAddViews.new
      buttons.make_root(last_ref_id)
      say "Which theater would you like?"
      buttons.views << createButton("#{theaters[0][:name]}",false)
      buttons.views << createButton("#{theaters[1][:name]}",false)
      buttons.views << createButton("#{theaters[2][:name]}",false)
      buttons.views << createButton("#{theaters[3][:name]}",false)
      buttons.views << createButton("#{theaters[4][:name]}",false)
      buttons.views << createButton("#{theaters[5][:name]}",false)
      send_object buttons
      request_completed
   end
end