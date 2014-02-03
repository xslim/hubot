
module.exports = (robot) ->
  robot.respond /talk to me$/i, ( msg ) ->
    # Simply reply
    msg.reply "Hello #{msg.envelope.user.name}. Your private JID is #{msg.envelope.user.privateChatJID}"

  robot.respond /talk to me in private$/i, ( msg ) ->
    msg.envelope.user.type = 'direct'
    msg.send "Hey #{msg.envelope.user.name}! You told me in room #{msg.envelope.user.room} to talk to you."