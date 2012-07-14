require 'cora'
require 'siri_objects'
require 'google_showtimes'

class SiriProxy::Plugin::MovieTimes < SiriProxy::Plugin
def initialize(config)
end

#  filter "SetRequestOrigin", direction: :from_iphone do |object|
#    puts "[Info - User Location] lat: #{object["properties"]["latitude"]}, long: #{object["properties"]["longitude"]}"
#  end
#12
  def organizeFilmsByTheater(film)
    theaters = Hash.new
    movies = Hash.new
    theaternames = []
    theaterinfo = []
    w = 0
    x = 0
    y = 0
    z = 0

      while w < film[1].length do
      if theaterinfo.include?(film[1][w][:cinema][:name]) == false
        theaterinfo = []
        theaterinfo << film[1][w][:cinema][:name]
        theaterinfo << film[1][w][:cinema][:address]
        theaterinfo << film[1][w][:cinema][:phone]
        theaternames << theaterinfo
      end
      w = w + 1
    end
    while x < theaternames.length do
      while y < film[1].length do
        showtimes = []
        while z < film[1][y][:showtimes].length do
          showtimes << film[1][y][:showtimes][z][:time]
          z = z + 1
        end
        movies[y] = { :name => film[1][y][:film][:name], :times => showtimes } if showtimes.length > 0
        y = y + 1
      end
      theaters[x] = { :info => { :name => theaternames[x][0], :address => theaternames[x][1], :phone => theaternames[x][2] }, :movies => movies }
      x = x + 1
    end
    return theaters
  end

  listen_for /Movie time(?:s)?/i do
     if location.country == "United States"
       say "Getting movie times for #{location.city}, #{location.state}"
       movies = GoogleShowtimes.for("#{location.city}%2C+#{location.state}")
     else
       say "Getting movie times for #{location.city}, #{location.country}"
       movies = GoogleShowtimes.for("#{location.city}%2C+#{location.country}")
     end
     theaters = organizeFilmsByTheater(movies)
     puts theaters
     request_completed
  end
end

