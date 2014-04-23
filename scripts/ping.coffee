# Description:
#   Utility commands surrounding Hubot uptime.
#
# Commands:
#   hubot ping - Reply with pong
#   hubot ping <host> - Check host is alive
#   hubot echo <text> - Reply back with <text>
#   hubot time - Reply with current time
#   hubot die - End hubot process

module.exports = (robot) ->
  robot.respond /PING$/i, (msg) ->
    msg.send "PONG"

  robot.respond /ECHO (.*)$/i, (msg) ->
    msg.send msg.match[1]

  robot.respond /TIME$/i, (msg) ->
    msg.send "Server time is: #{new Date()}"

  robot.respond /DIE$/i, (msg) ->
    msg.send "Goodbye, cruel world."
    process.exit 0
    
  robot.respond /ping (.*)$/i, (msg) ->
    host = msg.match[1]
    
    ping = require ("net-ping")
    session = ping.createSession()
    
    session.pingHost host, (error, target) ->
    if (error)
      if (error instanceof ping.RequestTimedOutError)
        msg.send "#{target}: Not alive"
      else
        msg.send "#{target}: #{error.toString()}"
    else
      msg.send "#{target}: Alive"

