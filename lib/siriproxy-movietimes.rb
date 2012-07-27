require 'cora'
require 'siri_objects'
require 'google_showtimes'
require 'geokit'

class SiriProxy::Plugin::MovieTimes < SiriProxy::Plugin
  
def initialize(config)
  Geokit::Geocoders::google = config['APIKey']
end

  filter "SetRequestOrigin", direction: :from_iphone do |object|
    puts "[Info - User Location] lat: #{object["properties"]["latitude"]}, long: #{object["properties"]["longitude"]}"
  end
  filter "SnippetAttributeOpened", direction: :from_iphone do |object|
    puts "[Info - SiriProxy::Plugin::MovieTimes] Got Command!"
  end
  filter "SendCommands", direction: :from_iphone do |object|
    puts "[Info - SiriProxy::Plugin::MovieTimes] Got Command!"
  end

  def organizeByTheater(film)
    theaters = Hash.new
    theaternames = []
    duplicatetheater = []
    w = 0
    x = 0
    
    while w < film[1].length do
      if duplicatetheater.include?(film[1][w][:cinema][:name]) == false
        theaterinfo = []
        duplicatetheater << film[1][w][:cinema][:name]
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
            time = film[1][y][:showtimes][z][:time].utc
            showtimes << time.strftime("%l:%M %P") if time.hour >= Time.now().hour
            z = z + 1
          end
          showtimes.sort
          showtimes.each {|a| a.strip! if a.respond_to? :strip! }
          showtimes.delete(showtimes.last)
          movies[movies.count] = { :name => film[1][y][:film][:name], :times => showtimes }
        end
        y = y + 1
      end
      theaters[x] = { :info => { :name => theaternames[x][0], :address => theaternames[x][1], :phone => theaternames[x][2] }, :movies => movies }
      x = x + 1
    end
    return theaters
  end
  
  def organizeByFilm(film)
    movies = Hash.new
    movienames = []
    duplicatemovie = []
    w = 0
    x = 0
    
    while w < film[1].length do
      if duplicatemovie.include?(film[1][w][:film][:name]) == false
        movieinfo = []
        duplicatemovie << film[1][w][:film][:name]
        movieinfo << film[1][w][:film][:name]
        movienames << movieinfo
       end
      w = w + 1
    end
    while x < movienames.length do
      y = 0
      theaters = Hash.new
      while y < film[1].length do
        if film[1][y][:film][:name] == movienames[x][0]
          showtimes = []
          z = 0
          while z < film[1][y][:showtimes].length do
            time = film[1][y][:showtimes][z][:time].utc
            showtimes << time.strftime("%l:%M %P") if time.hour >= Time.now().hour
            z = z + 1
          end
          showtimes.sort
          showtimes.each {|a| a.strip! if a.respond_to? :strip! }
          showtimes.delete(showtimes.last)
          theaters[theaters.count] = { :name => film[1][y][:cinema][:name], :address => film[1][y][:cinema][:address], :phone => film[1][y][:cinema][:phone], :times => showtimes }
        end
        y = y + 1
      end
      movies[x] = { :name => movienames[x][0], :theater => theaters }
      x = x + 1
    end
    return movies
  end

  def getMovieTimesLines(theaters,current)
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

  def getTheaterTimesLines(movies,current)
    theaterTimesLines = Hash.new

    if movies[current] != nil
      theater = movies[current][:theater]
      x = 0
      while x < theater.length do
        theaterTimesLines[x] = { :theater => theater[x][:name], :showtimes => theater[x][:times] }
        x = x + 1
      end
      movie = true
    else
      movie = false
    end

    if movie == false
      return false
    else
      return theaterTimesLines
    end
  end
 
  def getNum(num)
    if num =~ /Six/i or num =~ /Sixth/i or num =~ /6/i
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
    elsif num =~ /Sixteen/i or num =~ /Sixteenth/i or num =~ /16/i
      number = 16
    elsif num =~ /Seventeen/i or num =~ /Sevententh/i or num =~ /17/i
      number = 17
    elsif num =~ /Eighteen/i or num =~ /Eighteenth/i or num =~ /18/i
      number = 18
    elsif num =~ /Nineteen/i or num =~ /Nineteenth/i or num =~ /19/i
      number = 19
    elsif num =~ /Twenty/i or num =~ /Twentieth/i or num =~ /20/i
      number = 20
    elsif num =~ /21/i
      number = 21
    elsif num =~ /22/i
      number = 22
    elsif num =~ /23/i
      number = 23
    elsif num =~ /24/i
      number = 24
    elsif num =~ /25/i
      number = 25
    elsif num =~ /26/i
      number = 26
    elsif num =~ /27/i
      number = 27
    elsif num =~ /28/i
      number = 28
    elsif num =~ /29/i
      number = 29
    elsif num =~ /30/i
      number = 30
    elsif num =~ /31/i
      number = 31
    elsif num =~ /32/i
      number = 32
    elsif num =~ /33/i
      number = 33
    elsif num =~ /34/i
      number = 34
    elsif num =~ /35/i
      number = 35
    elsif num =~ /36/i
      number = 36
    elsif num =~ /37/i
      number = 37
    elsif num =~ /38/i
      number = 38
    elsif num =~ /39/i
      number = 39
    elsif num =~ /40/i
      number = 40
    elsif num =~ /41/i
      number = 41
    elsif num =~ /42/i
      number = 42
    elsif num =~ /43/i
      number = 43
    elsif num =~ /44/i
      number = 44
    elsif num =~ /45/i
      number = 45
    elsif num =~ /46/i
      number = 46
    elsif num =~ /47/i
      number = 47
    elsif num =~ /48/i
      number = 48
    elsif num =~ /49/i
      number = 49
    elsif num =~ /50/i
      number = 50
    elsif num =~ /One/i or num =~ /First/i or num =~ /1/i
      number = 1
    elsif num =~ /Two/i or num =~ /Second/i or num =~ /2/i
      number = 2
    elsif num =~ /Three/i or num =~ /Third/i or num =~ /3/i
      number = 3
    elsif num =~ /Four/i or num =~ /Fourth/i or num =~ /4/i
      number = 4
    elsif num =~ /Five/i or num =~ /Fifth/i or num =~ /5/i
      number = 5
    else
      number = nil
    end
    if number != nil
      return number
    else
      again = ask "I'm sorry but didn't get that. Could you say the number again?"
      getNum(again)
    end
  end
  
  def showtimesDisplay_Theater(theaters)
    theaterList = SiriAddViews.new
    theaterList.make_root(last_ref_id)
    theaterList.scrollToTop = true
    y = 0
    z = 1
    theaterArray = []
    while z <= theaters.length do
      theaterArray << SiriAnswerLine.new("#{z}) #{theaters[z-1][:info][:name]}")
      z = z + 1
    end
    list1 = SiriAnswer.new("Theaters near #{location.city}:", theaterArray)
    theaterList.views << SiriAnswerSnippet.new([list1])
    send_object theaterList
    x = ask "Which theater number would you like to see the showtimes for?"
    x = getNum(x) if x.is_a?(Integer) == false
    x = x - 1
    shows = getMovieTimesLines(theaters,x)
    showsList = SiriAddViews.new
    showsList.make_root(last_ref_id)
    showsList.scrollToTop = true
    if shows != false
      say "Here are the showtimes for #{theaters[x][:info][:name]}"
      movieArray = []
      while y < shows.length do
        movieArray << SiriAnswerLine.new("#{shows[y][:title]}")
        movieArray << SiriAnswerLine.new("#{shows[y][:showtimes].compact.join(', ')}")
        movieArray << SiriAnswerLine.new("line","https://lh6.googleusercontent.com/-yqZpJuCpqlc/UAh6QyCsnJI/AAAAAAAAAF4/bUeaewYVf5w/s600/Line.jpg")
        y = y + 1
      end
      list2 = SiriAnswer.new("#{theaters[x][:info][:name]}:", movieArray)
      showsList.views << SiriAnswerSnippet.new([list2])
      send_object showsList
    else
      say "I'm sorry but I don't know which theater you wanted."
    end
  end
  
  def showtimesDisplay_Movie(movies)
    movieList = SiriAddViews.new
    movieList.make_root(last_ref_id)
    movieList.scrollToTop = true
    y = 0
    z = 1
    movieArray = []
    while z <= movies.length do
      movieArray << SiriAnswerLine.new("#{z}) #{movies[z-1][:name]}")
      z = z + 1
    end
    list1 = SiriAnswer.new("Movies near Spring", movieArray)
    movieList.views << SiriAnswerSnippet.new([list1])
    send_object movieList
    x = ask "Which number movie would you like to see all showtimes for?"
    x = getNum(x) if x.is_a?(Integer) == false
    x = x - 1
    showings = getTheaterTimesLines(movies,x)
    showingsList = SiriAddViews.new
    showingsList.make_root(last_ref_id)
    showingsList.scrollToTop = true
    if showings != false
      say "Here are the showtimes for #{movies[x][:name]}"
      theaterArray = []
      while y < showings.length do
        theaterArray << SiriAnswerLine.new("#{showings[y][:theater]}")
        theaterArray << SiriAnswerLine.new("#{showings[y][:showtimes].compact.join(', ')}")
        theaterArray << SiriAnswerLine.new("line","https://lh6.googleusercontent.com/-yqZpJuCpqlc/UAh6QyCsnJI/AAAAAAAAAF4/bUeaewYVf5w/s600/Line.jpg")
        y = y + 1
      end
      list2 = SiriAnswer.new("#{movies[x][:name]}:", theaterArray)
      showingsList.views << SiriAnswerSnippet.new([list2])
      send_object showingsList
    else
      say "I'm sorry but I don't know which movie you wanted."
    end
  end
  
  listen_for /Movie time(?:s)? by theater/i do
    if location.country == "United States"
      movies = GoogleShowtimes.for("#{location.city}, #{location.state}")
      theaters = organizeByTheater(movies)
    else
      movies = GoogleShowtimes.for("#{location.city}, #{location.country}")
      theaters = organizeByTheater(movies)
    end
    showtimesDisplay_Theater(theaters)
    request_completed
  end
  
  listen_for /Movie time(?:s)? by movie/i do
    if location.country == "United States"
      movies = GoogleShowtimes.for("#{location.city}, #{location.state}")
      movies = organizeByFilm(movies)
    else
      movies = GoogleShowtimes.for("#{location.city}, #{location.country}")
      movies = organizeByFilm(movies)
    end
    showtimesDisplay_Movie(movies)
    request_completed
  end
  
  listen_for /Movie theater(?:s)?/i do
    if location.country == "United States"
      movies = GoogleShowtimes.for("#{location.city}, #{location.state}")
      theaters = organizeByTheater(movies)
      say "Here are the #{theaters.length} closest theaters to #{location.city}, #{location.state}"
    else
      movies = GoogleShowtimes.for("#{location.city}, #{location.country}")
      theaters = organizeByTheater(movies)
      say "Here are the #{theaters.length} closest theaters to #{location.city}, #{location.country}"
    end
    y = 0
    z = 0
    theatersView = SiriAddViews.new
    theatersView.make_root(last_ref_id)
    theatersView.scrollToTop = true
    map_snippet = SiriMapItemSnippet.new
    map_snippet.userCurrentLocation = true
    while z < theaters.length do
      theater = Geokit::Geocoders::GoogleGeocoder.geocode(theaters[z][:info][:address])
      if theater.success == true
        theaterMap = SiriActionableMapItem.new
        theaterMapBusiness = SiriBusinessItem.new
        theaterMapBusiness.name = theaters[z][:info][:name]
        theaterMapBusiness.totalNumberOfReviews = 1
        theaterMapBusiness.businessIds = {"yelp"=>"", "places"=>"", "localeze"=>""}
        theaterMapBusiness.reviews = SiriBusinessReview.new
        theaterMapBusiness.phoneNumbers = SiriBusinessPhoneNumber.new("#{theaters[z][:info][:phone]}","PRIMARY")
        theaterMapBusiness.rating = SiriBusinessRating.new
        theaterMapBusiness.extSessionGuid = ""
        theaterMap.detail = theaterMapBusiness
        theaterMap.label = theaters[z][:info][:name]
        theaterMapLocation = SiriLocation.new
        theaterMapLocation.street = theater.street_address
        theaterMapLocation.countryCode = theater.country_code
        theaterMapLocation.city = theater.city
        theaterMapLocation.stateCode = theater.state
        theaterMapLocation.latitude = theater.lat
        theaterMapLocation.longitude = theater.lng
        theaterMapLocation.postalCode = theater.zip
        theaterMap.location = theaterMapLocation
        theaterMapCommands = SiriSnippetAttributeOpenedCommand.new
        theaterMapCommands.request_id = "Get-Current-Movie-Theater"
        theaterMapCommands.attributeValue = "#{z}"
        theaterMapCommands.attributeName = "#{theaters[z][:info][:name]}"
        commands = SiriSendCommands.new
        commands.commands << theaterMapCommands
        theaterMap.commands << commands
        theaterMap.identifier = ""
        theaterMap.detailType = "BUSINESS_ITEM"
        map_snippet.items << theaterMap
      else
        theaterAddress = theaters[z][:info][:address]
        theaterAddress = theaterAddress[0..-21]
        theaterPhone = theaters[z][:info][:address]
        theaterPhone = theaterPhone[-18..-1]
        theater = Geokit::Geocoders::GoogleGeocoder.geocode(theaterAddress)
        theaterMap = SiriActionableMapItem.new
        theaterMapBusiness = SiriBusinessItem.new
        theaterMapBusiness.name = theaters[z][:info][:name]
        theaterMapBusiness.totalNumberOfReviews = 1
        theaterMapBusiness.businessIds = {"yelp"=>"", "places"=>"", "localeze"=>""}
        theaterMapBusiness.reviews = SiriBusinessReview.new
        theaterMapBusiness.phoneNumbers = SiriBusinessPhoneNumber.new("#{theaterPhone}#{theaters[z][:info][:phone]}","PRIMARY")
        theaterMapBusiness.rating = SiriBusinessRating.new
        theaterMapBusiness.extSessionGuid = ""
        theaterMap.detail = theaterMapBusiness
        theaterMap.label = theaters[z][:info][:name]
        theaterMapLocation = SiriLocation.new
        theaterMapLocation.street = theater.street_address
        theaterMapLocation.countryCode = theater.country_code
        theaterMapLocation.city = theater.city
        theaterMapLocation.stateCode = theater.state
        theaterMapLocation.latitude = theater.lat
        theaterMapLocation.longitude = theater.lng
        theaterMapLocation.postalCode = theater.zip
        theaterMap.location = theaterMapLocation
        theaterMapCommands = SiriSnippetAttributeOpenedCommand.new
        theaterMapCommands.request_id = "Get-Current-Movie-Theater"
        theaterMapCommands.attributeValue = "#{z}"
        theaterMapCommands.attributeName = "#{theaters[z][:info][:name]}"
        commands = SiriSendCommands.new
        commands.commands << theaterMapCommands
        theaterMap.commands << commands
        theaterMap.identifier = ""
        theaterMap.detailType = "BUSINESS_ITEM"
        map_snippet.items << theaterMap
      end
      z = z + 1
      sleep 0.1 # Because I occasionally get a crash from making too many google places requests too close together
    end
    theatersView.views << map_snippet
    send_object theatersView
#    showtimes = confirm "Would you like showtimes for one of these theaters?"
#    if showtimes
#      showtimesDisplay_Theater(theaters)
#    end
    request_completed
  end
end