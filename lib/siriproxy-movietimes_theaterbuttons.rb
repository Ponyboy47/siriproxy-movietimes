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
def createButton(text,more)
    utterance = "#{text}"
    startRequest = SiriStartRequest.new(utterance,true,false)
    sendCommand = SiriSendCommands.new
    sendCommand.commands << startRequest
    button = SiriButton.new(text)
    button.commands << sendCommand
    return button
end
def getTheaters(zip)
   doc = Nokogiri::HTML(open("http://www.fandango.com/#{zip}_movietimes"))
   theater = Array.new
   @theaters = doc.css('select.allTheaters  option').each do |item|
      theater << "#{item.content}"
   end
   theater.delete_at(0)
return theater
end
def showTimes(loc,more)
   if more == true
      theaters = getTheaters(location.postal_code)
      buttons = SiriAddViews.new
      buttons.make_root(last_ref_id)
      utterance = SiriAssistantUtteranceView.new("Here are more theaters..")
      buttons.views << utterance
      buttons.views << createButton("#{theaters[5]}",false)
      buttons.views << createButton("#{theaters[6]}",false)
      buttons.views << createButton("#{theaters[7]}",false)
      buttons.views << createButton("#{theaters[8]}",false)
      buttons.views << createButton("#{theaters[9]}",false)
      send_object buttons
   end
end
   listen_for /Movie times/i do
      say "Getting movie times for #{location.city}, #{location.state}"
      theaters = getTheaters(location.postal_code)
      buttons = SiriAddViews.new
      buttons.make_root(last_ref_id)
      say "Which theater would you like?"
      buttons.views << createButton("#{theaters[0]}",false)
      buttons.views << createButton("#{theaters[1]}",false)
      buttons.views << createButton("#{theaters[2]}",false)
      buttons.views << createButton("#{theaters[3]}",false)
      buttons.views << createButton("#{theaters[4]}",false)
      buttons.views << createButton("More Theaters..",true)
      send_object buttons
      request_completed
   end
end
