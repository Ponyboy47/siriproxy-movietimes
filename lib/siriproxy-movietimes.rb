require 'cora'
require 'siri_objects'
require 'google_showtimes'

class SiriProxy::Plugin::MovieTimes < SiriProxy::Plugin
def initialize(config)
end

  filter "SetRequestOrigin", direction: :from_iphone do |object|
    puts "[Info - User Location] lat: #{object["properties"]["latitude"]}, long: #{object["properties"]["longitude"]}"
  end

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
        movies[movies.count] = { :name => film[1][y][:film][:name], :times => showtimes } if showtimes.length > 0
        y = y + 1
      end
      theaters[x] = { :info => { :name => theaternames[x][0], :address => theaternames[x][1], :phone => theaternames[x][2] }, :movies => movies }
      x = x + 1
    end
    return theaters
  end

  def doEverythingElse(theaters,current)
    view = SiriAddViews.new
    view.make_root(last_ref_id)
    view.scrollToTop = true
    movieTimesLines1 = []
    movieTimesLines2 = []
    movieTimesLines3 = []
    movieTimesList1 = []
    movieTimesList2 = []
    movieTimesList3 = []

    if theaters[current] != nil
      movies1 = theaters[current][:movies]
      x = 0
      until x == (movies1.count - 1)
        movieTimesLines1 << SiriAnswerLine.new("#{movies1[x][:name]}")
        movieTimesLines1 << SiriAnswerLine.new("#{movies1[x][:times]}")
        x = x + 1
      end
      movieTimesList1 = SiriAnswer.new("#{theaters[current][:info][:name]}", movieTimesLines1)
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
        x = x + 1
      end
      movieTimesList2 = SiriAnswer.new("#{theaters[current][:info][:name]}", movieTimesLines2)
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
        x = x + 1
      end
      movieTimesList3 = SiriAnswer.new("#{theaters[current][:info][:name]}", movieTimesLines3)
      moreTheaters3 = true
    else
      moreTheaters3 = false
    end

    if moreTheaters1 == false && moreTheaters2 == false && moreTheaters3 == false
      return false
    else
      view.views << SiriAnswerSnippet.new(movieTimesList1)
      view.views << SiriAnswerSnippet.new(movieTimesList2)
      view.views << SiriAnswerSnippet.new(movieTimesList3)
      return view
    end
  end
  
  listen_for /Movie time(?:s)?/i do
    if location.country == "United States"
      say "Getting movie times for #{location.city}, #{location.state}"
      movies = GoogleShowtimes.for("#{location.city}%2C+#{location.state}")
      client = GoogleShowtimes::Client.new("#{location.city}%2C+#{location.state}")
    else
      say "Getting movie times for #{location.city}, #{location.country}"
      movies = GoogleShowtimes.for("#{location.city}%2C+#{location.country}")
      client = GoogleShowtimes::Client.new("#{location.city}%2C+#{location.country}")
    end
    puts client.movies_theaters
    theaters = organizeFilmsByTheater(movies)
    more = true
    x = 0
    until more == false
      shows = doEverythingElse(theaters,x)
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