# Description:
#   A simple REST service
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None
#
# URLS:
#   /rest/ping
#   /rest/test


module.exports = (robot) ->

  robot.router.get "/rest/ping", (req, res) ->
    res.end "PONG"

  robot.router.post "/rest/post", (req, res) ->
    res.end "PONG"

  robot.router.get "/rest/test", (req, res) ->
    res.end "Requested: #{JSON.stringify(req.query, null, 2)}\nHeaders:  #{JSON.stringify(req.headers, null, 2)}"
