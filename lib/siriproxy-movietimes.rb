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
      say "#{theaters}"
      movies1 = theaters[0][:movies]
      x = 0
      until x == (movies1.count - 1)
         y = 0
         movieTimesLines1 << SiriAnswerLine.new("#{movies1[:name]}")
         until y == (movies1[:times].count - 1)
            movieTimesLines1 << SiriAnswerLine.new("#{movies1[:times][y]}")
            y = y + 1
         end
         x = x+1
      end
      movieTimesList1 = SiriAnswer.new("#{theaters[0][:name]}", [movieTimesLines1])
      view1.views << SiriAnswerSnippet.new([movieTimesList1])
      
      movies2 = theaters[1][:movies]
      x = 0
      until x == (movies2.count - 1)
         y = 0
         movieTimesLines2 << SiriAnswerLine.new("#{movies2[:name]}")
         until y == (movies2[:times].count - 1)
            movieTimesLines2 << SiriAnswerLine.new("#{movies2[:times][y]}")
            y = y + 1
         end
         x = x+1
      end
      movieTimesList2 = SiriAnswer.new("#{theaters[1][:name]}", [movieTimesLines2])
      view2.views << SiriAnswerSnippet.new([movieTimesList2])
      
      movies3 = theaters[2][:movies]
      x = 0
      until x == (movies3.count - 1)
         y = 0
         movieTimesLines3 << SiriAnswerLine.new("#{movies3[:name]}")
         until y == (movies3[:times].count - 1)
            movieTimesLines3 << SiriAnswerLine.new("#{movies3[:times][y]}")
            y = y + 1
         end
         x = x+1
      end
      movieTimesList3 = SiriAnswer.new("#{theaters[2][:name]}", [movieTimesLines3])
      view3.views << SiriAnswerSnippet.new([movieTimesList3])
      
      send_object view1
      send_object view2
      send_object view3
      sleep 10
      if confirm "Would you like to see more theaters?"
        say "Here are the next three theaters..."
        view4 = SiriAddViews.new
        view5 = SiriAddViews.new
        view6 = SiriAddViews.new
        view4.make_root(last_ref_id)
        view5.make_root(last_ref_id)
        view6.make_root(last_ref_id)
        view4.scrollToTop = true
        view5.scrollToTop = false
        view6.scrollToTop = false
        movieTimesLines4 = Array.new
        movieTimesLines5 = Array.new
        movieTimesLines6 = Array.new
      
        movies4 = theaters[3][:movies]
        x = 0
        until x == (movies4.count - 1)
           y = 0
           movieTimesLines4 << SiriAnswerLine.new("#{movies4[:name]}")
           until y == (movies4[:times].count - 1)
              movieTimesLines4 << SiriAnswerLine.new("#{movies4[:times][y]}")
              y = y + 1
           end
          x = x+1
        end
        movieTimesList4 = SiriAnswer.new("#{theaters[3][:name]}", [movieTimesLines4])
        view4.views << SiriAnswerSnippet.new([movieTimesList4])
        
        movies5 = theaters[4][:movies]
        x = 0
        until x == (movies5.count - 1)
           y = 0
           movieTimesLines5 << SiriAnswerLine.new("#{movies5[:name]}")
           until y == (movies5[:times].count - 1)
              movieTimesLines5 << SiriAnswerLine.new("#{movies5[:times][y]}")
              y = y + 1
           end
           x = x+1
        end
        movieTimesList5 = SiriAnswer.new("#{theaters[4][:name]}", [movieTimesLines5])
        view5.views << SiriAnswerSnippet.new([movieTimesList5])
        
        movies6 = theaters[5][:movies]
        x = 0
        until x == (movies6.count - 1)
           y = 0
           movieTimesLines6 << SiriAnswerLine.new("#{movies6[:name]}")
           until y == (movies6[:times].count - 1)
              movieTimesLines6 << SiriAnswerLine.new("#{movies6[:times][y]}")
              y = y + 1
           end
           movieTimesLines6 << SiriAnswerLine.new("#{movies6[:times]}")
           x = x+1
        end
        movieTimesList6 = SiriAnswer.new("#{theaters[5][:name]}", [movieTimesLines6])
        view6.views << SiriAnswerSnippet.new([movieTimesList6])
        
        send_object view4
        send_object view5
        send_object view6
      end
      request_completed
   end
end
