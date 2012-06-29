require 'cora'
require 'siri_objects'
require 'movie_show_times'

class SiriProxy::Plugin::MovieTimes < SiriProxy::Plugin
def initialize(config)
end
   listen_for /Movie times/i do
      say "Getting movie times for Spring, Tx"#{location.city}, #{location.state}"
      movieShowTimes = MovieShowTimes::Crawler.new({ :location => 'Spring%2C+TX' })##{location.city}%2C+#{location.state}' })
      theaters = movieShowTimes.theaters
      view1 = SiriAddViews.new
      view2 = SiriAddViews.new
      view3 = SiriAddViews.new
      view1.make_root(last_ref_id)
      view2.make_root(last_ref_id)
      view3.make_root(last_ref_id)
      view1.scrollToTop = true
      view2.scrollToTop = false
      view3.scrollToTop = false
      movietimeslines1 = Array.new
      movietimeslines2 = Array.new
      movietimeslines3 = Array.new
      movies1 = movieShowTimes.theaters['#{theaters[0]["name"]}']["movies"]
      x = 0
      until x == (movies1.length - 1)
         movietimeslines1 << SiriAnswerLine.new("#{movies1["x"]['name']}")
         movietimeslines1 << SiriAnswerLine.new("#{movies1["x"]['times']}")
         x = x+1
      end
      movieTimesList1 = SiriAnswer.new("#{theaters[0]["name"]}", [movietimeslines1])
      view1.views << SiriAnswerSnippet.new([movietimesList1])
      
      movies2 = movieShowTimes.theaters['#{theaters[1]["name"]}']["movies"]
      x = 0
      until x == (movies2.length - 1)
         movietimeslines2 << SiriAnswerLine.new("#{movies2["x"]['name']}")
         movietimeslines2 << SiriAnswerLine.new("#{movies2["x"]['times']}")
         x = x+1
      end
      movieTimesList2 = SiriAnswer.new("#{theaters[1]["name"]}", [movietimeslines2])
      view2.views << SiriAnswerSnippet.new([movietimesList2])
      
      movies3 = movieShowTimes.theaters['#{theaters[2]["name"]}']["movies"]
      x = 0
      until x == (movies3.length - 1)
         movietimeslines3 << SiriAnswerLine.new("#{movies3["x"]['name']}")
         movietimeslines3 << SiriAnswerLine.new("#{movies3["x"]['times']}")
         x = x+1
      end
      movieTimesList3 = SiriAnswer.new("#{theaters[2]["name"]}", [movietimeslines3])
      view3.views << SiriAnswerSnippet.new([movietimesList3])
      send_object view1
      send_object view2
      send_object view3
      request_completed
   end
end
