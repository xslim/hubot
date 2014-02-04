
Util = require "util"
XMLJS = require("xml2js")


cinemas = 
  "100089": "Arena",
  "100101": "City",
  "100106": "De Munt",
  "100127": "Tuschinski"

getCinema = (cinemaId,cinemas) ->
  for code, name of cinemas
      return name if code is cinemaId
  return cinemaId

module.exports = (robot) ->
  robot.respond /(movies|pathe)( (today|tomorrow))?( in (.+))?/i, (msg) ->
    
    day = msg.match[3] or "today"
    location = msg.match[5] or "Amsterdam"
    
    daysOffset = 0 if day is "today"
    daysOffset = 1 if day is "tomorrow"
    
    #msg.send Util.inspect(msg.match, false, 2)
    msg.send "Movies #{day} in #{location} Pathe:"
    #return
    
    movies = []
    
    robot.http("http://mc2.sharewire.net/")
      .query({
        mc: 50
        b: 20131101
        v: '0.1'
        action: 'MC_ITEM'
        item: 'deze_week'
        params: "cityName="+location+"--daysOffset=#{daysOffset}"
      })
      .get() (err, res, body) ->
        parser = new XMLJS.Parser(explicitArray: true)
        parser.parseString body, (err, result) ->
          
          p_movies = result.swresponse.Message[0].Shows
          p_movies[0].Show.forEach (show) ->
            lng = parseInt(show.LanguageVersionID[0], 10)
            title = show.EventName[0]
            
            nl_match = /NL/.test(title)
            
            if lng != 12 and !nl_match # NL
              
              # title = title.replace /^\s*|\s*$/g, ''
              text = ""
              # text += "#{title}\n"
              
              #msg.send Util.inspect(show.sw_showtimes, false, 4)
              show.sw_showtimes.forEach (st) ->
                #msg.send Util.inspect(st, false, 2)
                site = getCinema(st['$'].SiteID, cinemas)
                t = st['_']
                text += "  #{site}: #{t}\n"
                
              q_title = title
              q_title = q_title.replace /IMAX/i, ''
              q_title = q_title.replace /3D/i, ''
              q_title = q_title.replace /HFR/, ''
              q_title = q_title.replace /^\s*|\s*$/ig, ''
              
              msg.http("http://omdbapi.com/")
                .query({
                  t: q_title
                })
                .get() (err, res, body) ->
                  one_movie = JSON.parse(body)
                  
                  imdb = one_movie.imdbRating
                  ms = one_movie.Metascore
                  
                  if parseFloat(imdb) > 5 and parseFloat(ms) > 45 
                    add = ""
                    add += ", Lng: #{lng}" if lng != 11 
                    out_text = "#{title} (#{one_movie.Year})\n"
                    out_text += "  IMDB: #{imdb} MS: #{ms}#{add}\n"
                    out_text += "  #{one_movie.Plot}\n"
                    out_text += text
                  
                    msg.send out_text
              
                  
                
              #msg.send title  + "sw_showtimes: " + Util.inspect(show.sw_showtimes, false, 2)
            #if link.rel is "alternate" and link.type is "text/html"
          # msg.send "Movies today in #{location}: \n\n#{text}"
          
          