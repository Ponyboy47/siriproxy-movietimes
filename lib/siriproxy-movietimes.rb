require 'cora'
require 'siri_objects'
require 'google_movies47'

class SiriProxy::Plugin::MovieTimes < SiriProxy::Plugin
def initialize(config)
end

   filter "SetRequestOrigin", direction: :from_iphone do |object|
     puts "[Info - User Location] lat: #{object["properties"]["latitude"]}, long: #{object["properties"]["longitude"]}"
   end

   listen_for /Movie times/i do
      if location.country == "United States"
        say "Getting movie times for #{location.city}, #{location.state}"
        movieShowTimes = GoogleMovies47::Crawler.new({ :city => location.city, :state => location.state })
      else
        say "Getting movie times for #{location.city}, #{location.country}"
        movieShowTimes = GoogleMovies47::Crawler.new({ :city => location.city, :state => location.country })
      end
      theaters = movieShowTimes.theaters
      view1 = SiriAddViews.new
#      view2 = SiriAddViews.new
#      view3 = SiriAddViews.new
      view1.make_root(last_ref_id)
#      view2.make_root(last_ref_id)
#      view3.make_root(last_ref_id)
#      view1.scrollToTop = true
#      view2.scrollToTop = false
#      view3.scrollToTop = false
      movieTimesLines1 = Array.new
#      movieTimesLines2 = Array.new
#      movieTimesLines3 = Array.new
      say "#{theaters}"
      say "#{theaters[0][:movies]}"
      movies1 = theaters[0][:movies]
      x = 0
      until x == (movies1.count - 1)
         y = 0
         movieTimesLines1 << SiriAnswerLine.new("#{movies1[x][:name]}")
         puts "#{movies1[x][:name]}"
         until y == (movies1[x][:times].count - 1)
            movieTimesLines1 << SiriAnswerLine.new("#{movies1[x][:times][y]}")
            puts "#{movies1[x][:times][y]}"
            y = y + 1
         end
         x = x+1
      end
      movieTimesList1 = SiriAnswer.new("#{theaters[0][:name]}", [movieTimesLines1])
      view1.views << SiriAnswerSnippet.new([movieTimesList1])
      
#      movies2 = theaters[1][:movies]
#      x = 0
#      until x == (movies2.count - 1)
#         y = 0
#         movieTimesLines2 << SiriAnswerLine.new("#{movies2[x][:name]}")
#         until y == (movies2[x][:times].count - 1)
#            movieTimesLines2 << SiriAnswerLine.new("#{movies2[x][:times][y]}")
#            y = y + 1
#         end
#         x = x+1
#      end
#      movieTimesList2 = SiriAnswer.new("#{theaters[1][:name]}", [movieTimesLines2])
#      view2.views << SiriAnswerSnippet.new([movieTimesList2])
#      
#      movies3 = theaters[2][:movies]
#      x = 0
#      until x == (movies3.count - 1)
#         y = 0
#         movieTimesLines3 << SiriAnswerLine.new("#{movies3[x][:name]}")
#         until y == (movies3[x][:times].count - 1)
#            movieTimesLines3 << SiriAnswerLine.new("#{movies3[x][:times][y]}")
#            y = y + 1
#         end
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
