require 'cora'
require 'siri_objects'
require 'google_movies'

class SiriProxy::Plugin::MovieTimes < SiriProxy::Plugin
def initialize(config)
end

   filter "SetRequestOrigin", direction: :from_iphone do |object|
     puts "[Info - User Location] lat: #{object["properties"]["latitude"]}, long: #{object["properties"]["longitude"]}"
   end

   listen_for /Movie times/i do
      if location.country == "United States"
        say "Getting movie times for #{location.city}, #{location.state}"
        movieShowTimes = GoogleMovies::Client.new("#{location.city}%2C+#{location.state}")
      else
        say "Getting movie times for #{location.city}, #{location.country}"
        movieShowTimes = GoogleMovies::Client.new("#{location.city}%2C+#{location.country}")
      end
      @theaters = movieShowTimes.movies_theaters
      view = SiriAddViews.new
      view.make_root(last_ref_id)
      view.scrollToTop = true
      movieTimesLines1 = []

      movies1 = @theaters[0].movies
      x = 0
      puts "#{movies1.length}"
      until x == (movies1.length - 1)
        puts "#{movies1[x].name}"
        puts "#{movies1[x].times}"
        movieTimesLines1 << SiriAnswerLine.new("#{movies1[x].name}")
        movieTimesLines1 << SiriAnswerLine.new("#{movies1[x].times}")
        x = x+1
      end
      movieTimesList1 = SiriAnswer.new("#{@theaters[0].name}", movieTimesLines1)
      
      movies2 = @theaters[1].movies
      x = 0
      puts "#{movies2.length}"
      until x == (movies2.length - 1)
        puts "#{movies2[x].name}"
        puts "#{movies2[x].times}"
        movieTimesLines2 << SiriAnswerLine.new("#{movies2[x].name}")
        movieTimesLines2 << SiriAnswerLine.new("#{movies2[x].times}")
        x = x+1
      end
      movieTimesList2 = SiriAnswer.new("#{@theaters[1].name}", movieTimesLines2)
      
      movies3 = @theaters[2].movies
      x = 0
      puts "#{movies3.length}"
      until x == (movies3.length - 1)
        puts "#{movies3[x].name}"
        puts "#{movies3[x].times}"
        movieTimesLines3 << SiriAnswerLine.new("#{movies3[x].name}")
        movieTimesLines3 << SiriAnswerLine.new("#{movies3[x].times}")
        x = x+1
      end
      movieTimesList3 = SiriAnswer.new("#{@theaters[2].name}", movieTimesLines3)
      view.views << SiriAnswerSnippet.new([movieTimesList1,movieTimesList2,movieTimesList3])
      
      send_object view
      
      request_completed
   end
end
