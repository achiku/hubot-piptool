# Description:
#   Utility commands surrounding Hubot uptime.
#
# Commands:
#   hubot pip-check <repo name> - Reply if updates are available
#   hubot pip-review <repo name> - Reply updated requirements


module.exports = (robot) ->
  robot.respond /(pip-check) (\w+)/i, (msg) ->
    msg.send 'check ' + msg.match[2]

  robot.respond /(pip-review) (\w+)/, (msg) ->
    msg.send 'review ' + msg.match[2]
