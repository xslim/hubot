# Description:
#   A simple REST HMAC service
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

crypto = require 'crypto'

hmacsha1 = (text, key) ->
  hmac = crypto.createHmac('sha1', key)
  
  # change to 'binary' if you want a binary digest
  #hmac.setEncoding('hex');

  # write in the text that you want the hmac digest for
  hmac.write(text);

  # you can't read from the stream until you call end()
  hmac.end();
  
  hash = hmac.read(); 

  return hmac

module.exports = (robot) ->

  robot.router.get "/rest/hmac", (req, res) ->
    key = req.query.key
    text = req.query.text
    hash = hmacsha1(text, key)
    res.end hash

  robot.router.post "/rest/hmac", (req, res) ->
    res.end "PONG"
