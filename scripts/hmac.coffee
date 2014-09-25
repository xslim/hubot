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
  hmac.setEncoding('base64');

  # write in the text that you want the hmac digest for
  hmac.write(text);

  # you can't read from the stream until you call end()
  hmac.end();

  hash = hmac.read();

  return hash

compputeFromReq = (req) ->
  key = req.query.key
  text = req.query.text
  hash = ""
  if key? && text?
    hash = hmacsha1(text, key)
    
  return hash

module.exports = (robot) ->
  
  # GET & POST
  robot.router.all "/rest/hmac", (req, res) ->
    res.end compputeFromReq(req)

  # GET & POST
  robot.router.all "/rest/hmac.json", (req, res) ->
    hash = compputeFromReq(req)
    hash = JSON.stringify({"hash": hash})
    res.end hash
