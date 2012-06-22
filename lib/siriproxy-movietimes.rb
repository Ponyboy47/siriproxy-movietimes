require 'cora'
require 'siri_objects'
require 'movie_show_times'

class SiriProxy::Plugin::MovieTimes < SiriProxy::Plugin
def initialize(config)
end
   listen_for /Movie times/i do
      say "Getting movie times for #{location.city}, #{location.state}"
      movieShowTimes = MovieShowTimes::Crawler.new({ :location => '#{location.city}' })
      
      request_completed
   end
end
