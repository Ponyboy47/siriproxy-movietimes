require 'cora'
require 'siri_objects'
require 'google_movies47'

class SiriProxy::Plugin::MovieTimes < SiriProxy::Plugin
def initialize(config)
end
   listen_for /Movie times/i do
      say "Getting movie times for Spring, Tx"#{location.city}, #{location.state}"
      movieShowTimes = GoogleMovies47::Crawler.new({ :city => 'Spring', :state => 'Texas'})##{location.city}%2C+#{location.state}' })
      theaters = movieShowTimes.theaters
      view1 = SiriAddViews.new
      view2 = SiriAddViews.new
      view3 = SiriAddViews.new
      view1.make_root(last_ref_id)
      view2.make_root(last_ref_id)
      view3.make_root(last_ref_id)
      view1.scrollToTop = true
      view2.scrollToTop = false
      view3.scrollToTop = false
      movieTimesLines1 = Array.new
      movieTimesLines2 = Array.new
      movieTimesLines3 = Array.new
      say "#{theaters[0][:movies]}"
      #say "#{theaters[0][:movies][:name]}"
      movies1 = theaters[0][0]
      x = 0
      until x == (movies1.count - 1)
         movieTimesLines1 << SiriAnswerLine.new("#{movies1[x][:name]}")
         movieTimesLines1 << SiriAnswerLine.new("#{movies1[x][:times]}")
         x = x+1
      end
      movieTimesList1 = SiriAnswer.new("#{theaters[0][:name]}", [movieTimesLines1])
      view1.views << SiriAnswerSnippet.new([movieTimesList1])
      
#      movies2 = theaters["#{theaters[1][:name]}"][:movies]
#      x = 0
#      until x == (movies2.length - 1)
#         movieTimesLines2 << SiriAnswerLine.new("#{movies2[x][:name]}")
#         movieTimesLines2 << SiriAnswerLine.new("#{movies2[x][:times]}")
#         x = x+1
#      end
#      movieTimesList2 = SiriAnswer.new("#{theaters[1][:name]}", [movieTimesLines2])
#      view2.views << SiriAnswerSnippet.new([movieTimesList2])
      
#      movies3 = theaters["#{theaters[2][:name]}"][:movies]
#      x = 0
#      until x == (movies3.length - 1)
#         movieTimesLines3 << SiriAnswerLine.new("#{movies3[x][:name]}")
#         movieTimesLines3 << SiriAnswerLine.new("#{movies3[x][:times]}")
#         x = x+1
#      end
#      movieTimesList3 = SiriAnswer.new("#{theaters[2][:name]}", [movieTimesLines3])
#      view3.views << SiriAnswerSnippet.new([movieTimesList3])
      
      send_object view1
#      send_object view2
#      send_object view3
      request_completed
   end
end
