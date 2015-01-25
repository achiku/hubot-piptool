# Description:
#   Utility commands surrounding Hubot uptime.
#
# Commands:
#   hubot pip-check <repo name> - Reply if updates are available
#   hubot pip-review <repo name> - Reply updated requirements

module.exports = (robot) ->
  robot.respond /(pip-check) (\w+)/i, (msg) ->
    msg.send 'start checking repository and PyPi ' + msg.match[2]
    @exec = require('child_process').exec
    command = 'python src/scripts/piptools.py'
    @exec command, (error, stdout, stderr) ->
      msg.send error
      msg.send stdout
      msg.send stderr

  robot.respond /(pip-review) (\w+)/, (msg) ->
    msg.send 'review ' + msg.match[2]

