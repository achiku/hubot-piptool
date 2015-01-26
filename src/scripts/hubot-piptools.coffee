# Description:
#   Utility commands surrounding Hubot uptime.
#
# Commands:
#   hubot pip-check <repo name> - Reply if updates are available
#   hubot pip-review <repo name> - Reply updated requirements

{PyPiTools} = require './piptools'
{GitHubReqFileParser} = require './githubtools'
github_api_token = process.env.HUBOT_GITHUB_API_TOKEN

module.exports = (robot) ->
  robot.respond /(pip-check) (.+) (.+) (.+)/i, (msg) ->
    userName = msg.match[2]
    repository = msg.match[3]
    reqFilePath = msg.match[4]
    msg.reply "check #{userName}/#{repository}:#{reqFilePath}"

    pypi = new PyPiTools
    gh = new GitHubReqFileParser userName, repository, github_api_token
    gh.fetch reqFilePath, (current_packages) ->
      for p in current_packages
        pypi.check p, (lib) ->
          if lib.is_latest
            line = "(successful)\t#{lib.name} #{lib.current_version} = #{lib.latest_version}\n"
          else
            line = "(failed)\t#{lib.name} #{lib.current_version} < #{lib.latest_version}\n"
          msg.send line

  robot.respond /(pip-review) (\w+)/, (msg) ->
    msg.send 'review ' + msg.match[2]
