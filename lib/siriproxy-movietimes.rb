require 'cora'
require 'siri_objects'
require 'nokogiri'
require 'open-uri'

class SiriProxy::Plugin::MovieTimes < SiriProxy::Plugin
def initialize(config)
end
def getTheaterURL(zip)
   doc = Nokogiri::HTML(open("http://www.movietickets.com/house_list.asp?ShowDate=0&SearchZip=#{zip}&SearchRadius=15&SearchRealID=0&SearchIMAX=0&SearchLang=0"))
   theaterURL = Array.new
   @theaterURL = doc.css('ul[style="margin: 10px 10px 0 5px"] li a').each do |item|
      theaterURL << item['href']
   end
return theaterURL
end
def getTheaters(zip)
   doc = Nokogiri::XML(open("http://www.movietickets.com/house_list.asp?ShowDate=0&SearchZip=#{zip}&SearchRadius=15&SearchRealID=0&SearchIMAX=0&SearchLang=0"))
   theaters = Array.new
   @theaters = doc.search('div ul li a').each do |item|
      theaters << "#{item.content}"
   end
return theaters
end
def getTitles(zip)
   doc = Nokogiri::HTML(open("http://www.fandango.com/#{zip}_movietimes"))
   titles = Array.new
   @titles = doc.css('').each do |item|
      titles << "#{item.content}"
   end
return titles
end
def getTimes(zip)
   doc = Nokogiri::HTML(open("http://www.fandango.com/#{zip}_movietimes"))
   times = Array.new
   @times = doc.css('').each do |item|
      times << "#{item.content}"
   end
return times
end
   listen_for /Movie times/i do
      say "Getting movie times for "#{location.city}, #{location.state}"
      theaterURL = getTheaterURL(77379)#location.postal_code,0)
      theaters = getTheaters(77379)#location.postal_code,0)
      #titles = getTitles(77379)#location.postal_code,0)
      #times = getTimes(77379)#location.postal_code,0)
      #view = SiriAddViews.new
      #view.make_root(last_ref_id)
      #answer = SiriAnswer.new("#{theaters[0]}", [
      #   SiriAnswerLine.new("#{titles[0]}"),
      #   SiriAnswerLine.new("--#{times[0]}")])
      #view.views << SiriAnswerSnippet.new([answer])
      #send_object view
      say "#{theaters}"
      request_completed
   end
end
