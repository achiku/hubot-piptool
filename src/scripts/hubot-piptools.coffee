# Description:
#   Utility commands surrounding Hubot uptime.
#
# Commands:
#   hubot pip-check <repo name> - Reply if updates are available
#   hubot pip-review <repo name> - Reply updated requirements

p = require './piptools'
g = require './githubtools'

module.exports = (robot) ->
  robot.respond /(pip-check) (\w+)/i, (msg) ->
    msg.reply 'check ' + msg.match[2]
    tool = new p.PyPiTools
    msg.send tool.check('../../src/requirements/sample.txt')

  robot.respond /(pip-review) (\w+)/, (msg) ->
    msg.send 'review ' + msg.match[2]
