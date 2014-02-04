MRMOVIE_UID = "504FC0F9-F2BC-4B1E-968F-0B95E726BF76"
MRMOVIE_KEY = "9e97ed703aa21effe5121d5229313b8472886e2d"


# 1391501456 - 9e97ed703aa21effe5121d5229313b8472886e2d
# 7f690f27de46242564cf17fb233b6c65e7cc062c - /api/json/?method=movies&loc=Amsterdam&srt=time&page=1&day=today&uid=504FC0F9-F2BC-4B1E-968F-0B95E726BF76&time=1391525158&os=ios&key=

# 30604479d3eecff4481d07586f2f719c853f4a0f-  /api/json/?method=moviesPicture&time=1391525163&uid=504FC0F9-F2BC-4B1E-968F-0B95E726BF76&picture_id=16367.104&width=130&height=184&key=
# fc859990134bd2c16eb9c5839c3b17f619b6e9b7 - /api/json/?method=moviesPicture&time=1391525163&uid=504FC0F9-F2BC-4B1E-968F-0B95E726BF76&picture_id=17373.104&width=130&height=184&key=
# f460a82844d5560b1d0fc2ac7e25932c25159b38 - /api/json/?method=moviesPicture&time=1391525163&uid=504FC0F9-F2BC-4B1E-968F-0B95E726BF76&picture_id=19140.104&width=130&height=184&key=



Util = require "util"

module.exports = (robot) ->
  robot.respond /(mrmovie)( today)?( .*)?/i, (msg) ->
    day = msg.match[1] or "today"
    location = msg.match[3] or "Amsterdam"
    time = "1391501456"
    
    robot.http("http://api.nl.mrmovie.com/api/json/")
      .query({
        method: "movies"
        loc: location
        srt: 'time'
        page: 1
        day: day
        time: time
        os: 'ios'
        uid: MRMOVIE_UID
        key: MRMOVIE_KEY
      })
      .get() (err, res, body) ->
        msg.send "res: " + Util.inspect(res, false, 4)
        msg.send "Error: " + Util.inspect(err, false, 4)
        msg.send "Body: " + Util.inspect(body, false, 4)
        
        movies = JSON.parse(body)
        
        unless videos?
          msg.send "No movies results"
          return
        
        output = Util.inspect(movies, {showHidden: true, depth: null, color: true})
        msg.send output