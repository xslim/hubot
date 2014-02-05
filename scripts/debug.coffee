Util = require "util"

module.exports = (robot) ->
  
  auth_roles = ['hubot-dev']
  
  robot.respond /debug brain$/i, (msg) ->
    return unless robot.auth.cancan(auth_roles, msg)
    output = Util.inspect(robot.brain.data, {showHidden: true, depth: null, color: true})
    msg.send "Brain data:\n" + output
    
  robot.respond /debug env$/i, (msg) ->
    return unless robot.auth.cancan(auth_roles, msg)
    output = Util.inspect(process.env, {showHidden: true, depth: 4, color: true})
    msg.send "Env:\n" + output

  robot.respond /debug me$/i, (msg) ->
    msg_user = Util.inspect(msg.message.user, {showHidden: true, depth: 4, color: true})
    msg.send "Your data is:\n" + msg_user
    
    
  robot.respond /save brain$/i, (msg) ->
    return unless robot.auth.cancan(auth_roles, msg)
    robot.brain.save()
    msg.send "I'm saved!"