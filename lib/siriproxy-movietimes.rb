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

  def getNum(num)   #Let's hope there's less than 50 movies/theaters!
    if /Ten/i.match(num) or /10/.match(num)
      number = 10
    elsif /Eleven/i.match(num) or /11/.match(num)
      number = 11
    elsif /Twelve/i.match(num) or /Twelfth/i.match(num) or /12/.match(num)
      number = 12
    elsif /Thirteen/i.match(num) or /13/.match(num)
      number = 13
    elsif /Fourteen/i.match(num) or /14/.match(num)
      number = 14
    elsif /Fifteen/i.match(num) or /15/.match(num)
      number = 15
    elsif /Sixteen/i.match(num) or /16/.match(num)
      number = 16
    elsif /Seventeen/i.match(num) or /17/.match(num)
      number = 17
    elsif /Eighteen/i.match(num) or /18/.match(num)
      number = 18
    elsif /Nineteen/i.match(num) or /19/.match(num)
      number = 19
    elsif /Twenty One/i.match(num) or /Twenty First/i.match(num) or /21/.match(num)
      number = 21
    elsif /Twenty Two/i.match(num) or /Twenty Second/i.match(num) or /22/.match(num)
      number = 22
    elsif /Twenty Three/i.match(num) or /Twenty Third/i.match(num) or /23/.match(num)
      number = 23
    elsif /Twenty Four/i.match(num) or /24/.match(num)
      number = 24
    elsif /Twenty Five/i.match(num) or /Twenty Fifth/i.match(num) or /25/.match(num)
      number = 25
    elsif /Twenty Six/i.match(num) or /26/.match(num)
      number = 26
    elsif /Twenty Seven/i.match(num) or /27/.match(num)
      number = 27
    elsif /Twenty Eight/i.match(num) or /28/.match(num)
      number = 28
    elsif /Twenty Nine/i.match(num) or /Twenty Ninth/i.match(num) or /29/.match(num)
      number = 29
    elsif /Twenty/i.match(num) or /Twentieth/i.match(num) or /20/.match(num)
      number = 20
    elsif /Thirty One/i.match(num) or /Thirty First/i.match(num) or /31/.match(num)
      number = 31
    elsif /Thirty Two/i.match(num) or /Thirty Second/i.match(num) or /32/.match(num)
      number = 32
    elsif /Thirty Three/i.match(num) or /Thirty Third/i.match(num) or /33/.match(num)
      number = 33
    elsif /Thirty Four/i.match(num) or /34/.match(num)
      number = 34
    elsif /Thirty Five/i.match(num) or /Thirty Fifth/i.match(num) or /35/.match(num)
      number = 35
    elsif /Thirty Six/i.match(num) or /36/.match(num)
      number = 36
    elsif /Thirty Seven/i.match(num) or /37/.match(num)
      number = 37
    elsif /Thirty Eight/i.match(num) or /38/.match(num)
      number = 38
    elsif /Thirty Nine/i.match(num) or /Thirty Ninth/i.match(num) or /39/.match(num)
      number = 39
    elsif /Thirty/i.match(num) or /Thirtieth/i.match(num) or /30/.match(num)
      number = 30
    elsif /Fourty One/i.match(num) or /Fourty First/i.match(num) or /41/.match(num)
      number = 41
    elsif /Fourty Two/i.match(num) or /Fourty Second/i.match(num) or /42/.match(num)
      number = 42
    elsif /Fourty Three/i.match(num) or /Fourty Third/i.match(num) or /43/.match(num)
      number = 43
    elsif /Fourty Four/i.match(num) or /44/.match(num)
      number = 44
    elsif /Fourty Five/i.match(num) or /Fourty Fifth/i.match(num) or /45/.match(num)
      number = 45
    elsif /Fourty Six/i.match(num) or /46/.match(num)
      number = 46
    elsif /Fourty Seven/i.match(num) or /47/.match(num)
      number = 47
    elsif /Fourty Eight/i.match(num) or /48/.match(num)
      number = 48
    elsif /Fourty Nine/i.match(num) or num.match(/Fourty Ninth/i) or /49/.match(num)
      number = 49
    elsif /Fourty/i.match(num) or /Fourtieth/i.match(num) or /40/.match(num)
      number = 40
    elsif /Fifty/i.match(num) or /Fiftieth/i.match(num) or /50/.match(num)
      number = 50
    elsif /Two/i.match(num) or /Second/i.match(num) or /2/.match(num)
      number = 2
    elsif /Three/i.match(num) or /Third/i.match(num) or /3/.match(num)
      number = 3
    elsif /Four/i.match(num) or /4/.match(num)
      number = 4
    elsif /Five/i.match(num) or /Fifth/i.match(num) or /5/.match(num)
      number = 5
    elsif /Six/i.match(num) or /6/.match(num)
      number = 6
    elsif /Seven/i.match(num) or /7/.match(num)
      number = 7
    elsif /Eight/i.match(num) or /8/.match(num)
      number = 8
    elsif /Nine/i.match(num) or /Ninth/i.match(num) or /9/.match(num)
      number = 9
    elsif /One/i.match(num) or /First/i.match(num) or /1/.match(num)
      number = 1
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
      w += 1
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
            z += 1
          end
          showtimes.sort
          showtimes.each {|a| a.strip! if a.respond_to? :strip! }
          showtimes.delete(showtimes.last)
          movies[movies.count] = { :name => film[1][y][:film][:name], :times => showtimes }
        end
        y += 1
      end
      theaters[x] = { :info => { :name => theaternames[x][0], :address => theaternames[x][1], :phone => theaternames[x][2] }, :movies => movies }
      x += 1
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
      w += 1
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
            z += 1
          end
          showtimes.sort
          showtimes.each {|a| a.strip! if a.respond_to? :strip! }
          showtimes.delete(showtimes.last)
          theaters[theaters.count] = { :name => film[1][y][:cinema][:name], :address => film[1][y][:cinema][:address], :phone => film[1][y][:cinema][:phone], :times => showtimes }
        end
        y += 1
      end
      movies[x] = { :name => movienames[x][0], :theater => theaters }
      x += 1
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
        x += 1
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
        x += 1
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
  
  def showtimesDisplay_Theater(theaters)
    theaterList = SiriAddViews.new
    theaterList.make_root(last_ref_id)
    theaterList.scrollToTop = true
    y = 0
    z = 1
    theaterArray = []
    while z <= theaters.length do
      theaterArray << SiriAnswerLine.new("#{z}) #{theaters[z-1][:info][:name]}")
      z += 1
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
        movieArray << SiriAnswerLine.new("line","https://lh4.googleusercontent.com/-4SvQ10l0FUw/UBbsaIuRHPI/AAAAAAAAAGU/PUsZctqN58I/w512-h1-k/horizontalline.jpg")
        y += 1
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
      z += 1
    end
    list1 = SiriAnswer.new("Movies near #{location.city}", movieArray)
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
        theaterArray << SiriAnswerLine.new("line","https://lh4.googleusercontent.com/-4SvQ10l0FUw/UBbsaIuRHPI/AAAAAAAAAGU/PUsZctqN58I/w512-h1-k/horizontalline.jpg")
        y += 1
      end
      list2 = SiriAnswer.new("#{movies[x][:name]}:", theaterArray)
      showingsList.views << SiriAnswerSnippet.new([list2])
      send_object showingsList
    else
      say "I'm sorry but I don't know which movie you wanted."
    end
  end
  
  listen_for /Theater show(?: )?time(?:s)?/i do
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
  
  listen_for /Movie show(?: )?time(?:s)?/i do
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
  
  listen_for /Movie times(?:s)? for (.*)/i do |day|
    now = Time.now().utc
    if /Today/i.match(day)
      date = 0
    elsif /Tomorrow/i.match(day)
      date = 1
    elsif /Sunday/i.match(day)
      if now.wday == 0
        date = 0
      elsif now.wday == 1
        date = "Sorry but I can only get movie times for the next three days"
      elsif now.wday == 2
        date = "Sorry but I can only get movie times for the next three days"
      elsif now.wday == 3
        date = "Sorry but I can only get movie times for the next three days"
      elsif now.wday == 4
        date = 3
      elsif now.wday == 5
        date = 2
      elsif now.wday == 6
        date = 1
      end
    elsif /Monday/i.match(day)
      if now.wday == 0
        date = 1
      elsif now.wday == 1
        date = 0
      elsif now.wday == 2
        date = "Sorry but I can only get movie times for the next three days"
      elsif now.wday == 3
        date = "Sorry but I can only get movie times for the next three days"
      elsif now.wday == 4
        date = "Sorry but I can only get movie times for the next three days"
      elsif now.wday == 5
        date = 3
      elsif now.wday == 6
        date = 2
      end
    elsif /Tuesday/i.match(day)
      if now.wday == 0
        date = 2
      elsif now.wday == 1
        date = 1
      elsif now.wday == 2
        date = 0
      elsif now.wday == 3
        date = "Sorry but I can only get movie times for the next three days"
      elsif now.wday == 4
        date = "Sorry but I can only get movie times for the next three days"
      elsif now.wday == 5
        date = "Sorry but I can only get movie times for the next three days"
      elsif now.wday == 6
        date = 3
      end
    elsif /Wednesday/i.match(day)
      if now.wday == 0
        date = 3
      elsif now.wday == 1
        date = 2
      elsif now.wday == 2
        date = 1
      elsif now.wday == 3
        date = 0
      elsif now.wday == 4
        date = "Sorry but I can only get movie times for the next three days"
      elsif now.wday == 5
        date = "Sorry but I can only get movie times for the next three days"
      elsif now.wday == 6
        date = "Sorry but I can only get movie times for the next three days"
      end
    elsif /Thursday/i.match(day)
      if now.wday == 0
        date = "Sorry but I can only get movie times for the next three days"
      elsif now.wday == 1
        date = 3
      elsif now.wday == 2
        date = 2
      elsif now.wday == 3
        date = 1
      elsif now.wday == 4
        date = 0
      elsif now.wday == 5
        date = "Sorry but I can only get movie times for the next three days"
      elsif now.wday == 6
        date = "Sorry but I can only get movie times for the next three days"
      end
    elsif /Friday/i.match(day)
      if now.wday == 0
        date = "Sorry but I can only get movie times for the next three days"
      elsif now.wday == 1
        date = "Sorry but I can only get movie times for the next three days"
      elsif now.wday == 2
        date = 3
      elsif now.wday == 3
        date = 2
      elsif now.wday == 4
        date = 1
      elsif now.wday == 5
        date = 0
      elsif now.wday == 6
        date = "Sorry but I can only get movie times for the next three days"
      end
    elsif /Saturday/i.match(day)
      if now.wday == 0
        date = "Sorry but I can only get movie times for the next three days"
      elsif now.wday == 1
        date = "Sorry but I can only get movie times for the next three days"
      elsif now.wday == 2
        date = "Sorry but I can only get movie times for the next three days"
      elsif now.wday == 3
        date = 3
      elsif now.wday == 4
        date = 2
      elsif now.wday == 5
        date = 1
      elsif now.wday == 6
        date = 0
      end
    end
    if date.is_a? (Integer)
      if location.country == "United States"
        movies = GoogleShowtimes.for("#{location.city}, #{location.state}&date=#{date}")
        movies = organizeByFilm(movies)
      else
        movies = GoogleShowtimes.for("#{location.city}, #{location.country}&date=#{date}")
        movies = organizeByFilm(movies)
      end
      showtimesDisplay_Movie(movies)
    else
      say date
    end
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
#        theaterMapCommands = SiriSnippetAttributeOpenedCommand.new
#        theaterMapCommands.request_id = "Get-Current-Movie-Theater"
#        theaterMapCommands.attributeValue = "#{z}"
#        theaterMapCommands.attributeName = "#{theaters[z][:info][:name]}"
        commands = SiriSendCommands.new
#        commands.commands << theaterMapCommands
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
#        theaterMapCommands = SiriSnippetAttributeOpenedCommand.new
#        theaterMapCommands.request_id = "Get-Current-Movie-Theater"
#        theaterMapCommands.attributeValue = "#{z}"
#        theaterMapCommands.attributeName = "#{theaters[z][:info][:name]}"
        commands = SiriSendCommands.new
#        commands.commands << theaterMapCommands
        theaterMap.commands << commands
        theaterMap.identifier = ""
        theaterMap.detailType = "BUSINESS_ITEM"
        map_snippet.items << theaterMap
      end
      z += 1
      sleep 0.1 # Because I occasionally get a crash from making too many google places requests too close together
    end
    theatersView.views << map_snippet
    send_object theatersView
    showtimes = confirm "Would you like showtimes for one of these theaters?"
    if showtimes
      showtimesDisplay_Theater(theaters)
    end
    request_completed
  end
end