require 'cora'
require 'siri_objects'
require 'google_movies47'

class SiriProxy::Plugin::MovieTimes < SiriProxy::Plugin
def initialize(config)
end

   filter "SetRequestOrigin", direction: :from_iphone do |object|
     puts "[Info - User Location] lat: #{object["properties"]["latitude"]}, long: #{object["properties"]["longitude"]}"
   end
   
   def getEverything(theaters,current)
      view = SiriAddViews.new
      view.make_root(last_ref_id)
      view.scrollToTop = true
      movieTimesLines1 = []
      movieTimesLines2 = []
      movieTimesLines3 = []
      movieTimesList = []
      
      if theaters[current] != nil
        movies1 = theaters[current][:movies]
        x = 0
        until x == (movies1.count - 1)
           movieTimesLines1 << SiriAnswerLine.new("#{movies1[x][:name]}")
           movieTimesLines1 << SiriAnswerLine.new("#{movies1[x][:times]}")
           x = x+1
        end
        movieTimesList = SiriAnswer.new("#{theaters[current][:name]}", movieTimesLines1)
        moreTheaters1 = true
      else
        moreTheaters1 = false
      end
      
      current = current + 1
      if theaters[current] != nil
        movies2 = theaters[current][:movies]
        x = 0
        until x == (movies2.count - 1)
           movieTimesLines2 << SiriAnswerLine.new("#{movies2[x][:name]}")
           movieTimesLines2 << SiriAnswerLine.new("#{movies2[x][:times]}")
           x = x+1
        end
        movieTimesList = SiriAnswer.new("#{theaters[current][:name]}", movieTimesLines2)
        moreTheaters2 = true
      else
        moreTheaters2 = false
      end
      
      current = current + 1
      if theaters[current] != nil
        movies3 = theaters[current][:movies]
        x = 0
        until x == (movies3.count - 1)
           movieTimesLines3 << SiriAnswerLine.new("#{movies3[x][:name]}")
           movieTimesLines3 << SiriAnswerLine.new("#{movies3[x][:times]}")
           x = x+1
        end
        movieTimesList = SiriAnswer.new("#{theaters[current][:name]}", movieTimesLines3)
        moreTheaters3 = true
      else
        moreTheaters3 = false
      end
    
    if moreTheaters1 == false && moreTheaters2 == false && moreTheaters3 == false
      return false
    else
      view.views << SiriAnswerSnippet.new(movieTimesList)
      return view
    end
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
      more = true
      x = 0
      until more == false
        shows = getEverything(theaters,x)
        if shows != false
          send_object shows
          more = confirm "Would you like to see more theaters?"
        else
          say "I'm sorry but there are no more theaters near #{location.city}."
          more = false
        end
        x = x + 3
      end
      request_completed
   end
end
