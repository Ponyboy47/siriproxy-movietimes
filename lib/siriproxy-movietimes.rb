require 'cora'
require 'siri_objects'
require 'google_movies'

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
    
    if theaters[current].movies != nil
      movies1 = theaters[current].movies
      x = 0
      until x == (movies1.length - 1)
        movieTimesLines1 << SiriAnswerLine.new("#{movies1[x].name}")
        movieTimesLines1 << SiriAnswerLine.new("#{movies1[x].times}")
        x = x+1
      end
      movieTimesList << SiriAnswer.new("#{theaters[current].name}", movieTimesLines1)
    end
    
    current = current + 1
    if theaters[current].movies != nil
      movies2 = theaters[current].movies
      x = 0
      until x == (movies2.length - 1)
        movieTimesLines2 << SiriAnswerLine.new("#{movies2[x].name}")
        movieTimesLines2 << SiriAnswerLine.new("#{movies2[x].times}")
        x = x+1
      end
      movieTimesList << SiriAnswer.new("#{theaters[current].name}", movieTimesLines2)
    end
    
    current = current + 1
    if theaters[current].movies != nil
     movies3 = theaters[current].movies
      x = 0
      until x == (movies3.length - 1)
        movieTimesLines3 << SiriAnswerLine.new("#{movies3[x].name}")
        movieTimesLines3 << SiriAnswerLine.new("#{movies3[x].times}")
        x = x+1
      end
      movieTimesList << SiriAnswer.new("#{theaters[current].name}", movieTimesLines3)
    end
    if movieTimesList != nil
      view.views << SiriAnswerSnippet.new(movieTimesList)
      return view
    else
      say "I'm sorry but there are no more theaters near #{location.city}."
      request_completed
    end
  end
  
   listen_for /Movie times/i do
      if location.country == "United States"
        say "Getting movie times for #{location.city}, #{location.state}"
        movieShowTimes = GoogleMovies::Client.new("#{location.city}%2C+#{location.state}")
      else
        say "Getting movie times for #{location.city}, #{location.country}"
        movieShowTimes = GoogleMovies::Client.new("#{location.city}%2C+#{location.country}")
      end
      theaters = movieShowTimes.movies_theaters
      shows = getEverything(theaters,0)
      
      send_object shows
      
      more = confirm "Would you like to see more theaters?"
      x = 3
      until more == false
        shows1 = getEverything(theaters,x)
        send_object shows1
        more = confirm "Would you like to see more theaters?"
        x = x + 3
      end
      request_completed
   end
end
