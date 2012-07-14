require 'cora'
require 'siri_objects'
require 'google_showtimes'

class SiriProxy::Plugin::MovieTimes < SiriProxy::Plugin
def initialize(config)
end

  filter "SetRequestOrigin", direction: :from_iphone do |object|
    puts "[Info - User Location] lat: #{object["properties"]["latitude"]}, long: #{object["properties"]["longitude"]}"
  end
  
  def getTheaters(film)
    theaters = Array.new
    film.each do |f|
      theaters << f[1][:cinema][:name]
    end
    return theaters
  end
  def organizeFilmsByTheater(films)
    theaters = [][]
    films.each do |f|
      theaters[f[1][:cinema][:name]] << f[1][:film][:name]
    end
  end
  
  listen_for /Movie time(?:s)?/i do
     if location.country == "United States"
       say "Getting movie times for #{location.city}, #{location.state}"
       movies = GoogleShowtimes.for("#{location.city}%2C+#{location.state}")
     else
       say "Getting movie times for #{location.city}, #{location.country}"
       movies = GoogleShowtimes.for("#{location.city}%2C+#{location.country}")
     end
     #theaters = getTheaters(movies)
     puts "FIRST THING #{movies[1][1][0]}"
     puts "SECOND THING #{movies[2]}"
     request_completed
  end
end
