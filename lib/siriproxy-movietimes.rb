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
    theaternames = []
    theaterinfo = []
    w = 0
    x = 0
    
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
      y = 0
      movies = Hash.new
      while y < film[1].length do
        if film[1][y][:cinema][:name] == theaternames[x][0]
          showtimes = []
          z = 0
          while z < film[1][y][:showtimes].length do
            showtimes << film[1][y][:showtimes][z][:time].strftime("%H:%M")
            z = z + 1
          end
          movies[movies.count] = { :name => film[1][y][:film][:name], :times => showtimes }
        end
        y = y + 1
      end
      theaters[x] = { :info => { :name => theaternames[x][0], :address => theaternames[x][1], :phone => theaternames[x][2] }, :movies => movies }
      x = x + 1
    end
    return theaters
  end

  def doEverythingWithoutWolfram(theaters,current)
    movieTimesLines = Hash.new

    if theaters[current] != nil
      movies = theaters[current][:movies]
      x = 0
      while x < movies.length do
        movieTimesLines[x] = { :title => movies[x][:name], :showtimes => movies[x][:times] }
        x = x + 1
      end
      theater = true
    else
      theater = false
    end

    if theater == false
      return false
    else
      return movieTimesLines
    end
  end
 
  def getNum(num)
    if num =~ /One/i or num =~ /First/i or num =~ /1/i
      number = 1
    elsif num =~ /Two/i or num =~ /Second/i or num =~ /2/i
      number = 2
    elsif num =~ /Three/i or num =~ /Third/i or num =~ /3/i
      number = 3
    elsif num =~ /Four/i or num =~ /Fourth/i or num =~ /4/i
      number = 4
    elsif num =~ /Five/i or num =~ /Fifth/i or num =~ /5/i
      number = 5
    elsif num =~ /Six/i or num =~ /Sixth/i or num =~ /6/i
      number = 6
    elsif num =~ /Seven/i or num =~ /Seventh/i or num =~ /7/i
      number = 7
    elsif num =~ /Eight/i or num =~ /Eighth/i or num =~ /8/i
      number = 8
    elsif num =~ /Nine/i or num =~ /Ninth/i or num =~ /9/i
      number = 9
    elsif num =~ /Ten/i or num =~ /Tenth/i or num =~ /10/i
      number = 10
    elsif num =~ /Eleven/i or num =~ /Eleventh/i or num =~ /11/i
      number = 11
    elsif num =~ /Twelve/i or num =~ /Twelfth/i or num =~ /12/i
      number = 12
    elsif num =~ /Thirteen/i or num =~ /Thirteenth/i or num =~ /13/i
      number = 13
    elsif num =~ /Fourteen/i or num =~ /Fourteenth/i or num =~ /14/i
      number = 14
    elsif num =~ /Fifteen/i or num =~ /Fifteenth/i or num =~ /15/i
      number = 15
    end
    return number
  end
  
  listen_for /Movie time(?:s)?/i do
    if location.country == "United States"
      movies = GoogleShowtimes.for("#{location.city}%2C+#{location.state}")
      theaters = organizeFilmsByTheater(movies)
      say "Here are the #{theaters.length} closest theaters to #{location.city}, #{location.state}"
    else
      movies = GoogleShowtimes.for("#{location.city}%2C+#{location.country}")
      theaters = organizeFilmsByTheater(movies)
      say "Here are the #{theaters.length} closest theaters to #{location.city}, #{location.country}"
    end
    
    y = 0
    z = 1
    while z <= theaters.length do
      say "#{z}) #{theaters[z-1][:info][:name]}", spoken: ""
      z = z + 1
    end
    x = ask "Which number theater would you like to see the showtimes for?"
    x = getNum(x) if x.is_a?(Integer) == false
    x = x - 1
    shows = doEverythingWithoutWolfram(theaters,x)
    if shows != false
      say "Here are the showtimes for #{theaters[x][:info][:name]}"
      while y < shows.length do
        say "#{y+1}: #{shows[y][:title]}", spoken: ""
        say "   #{shows[y][:showtimes]}", spoken: ""
        y = y + 1
      end
    else
      say "I'm sorry but I don't know which theater you wanted."
    end
    request_completed
  end
  
  listen_for /Movie theater(?:s)?/i do
    if location.country == "United States"
      movies = GoogleShowtimes.for("#{location.city}%2C+#{location.state}")
      theaters = organizeFilmsByTheater(movies)
      say "Here are the #{theaters.length} closest theaters to #{location.city}, #{location.state}"
    else
      movies = GoogleShowtimes.for("#{location.city}%2C+#{location.country}")
      theaters = organizeFilmsByTheater(movies)
      say "Here are the #{theaters.length} closest theaters to #{location.city}, #{location.country}"
    end
    
    y = 1
    while y <= theaters.length do
      say "#{y}) #{theaters[y-1][:info][:name]}", spoken: ""
      y = y + 1
    end
    x = ask "Which number theater would you like?"
    x = getNum(x) if x.is_a?(Integer) == false
    x = x - 1
    say "Here is the address and phone number for #{theaters[x][:info][:name]}"
    say "#{theaters[x][:info][:address]}", spoken: "" #Will work on inserting map here
    say "#{theaters[x][:info][:phone]}", spoken: ""
    request_completed
  end
end