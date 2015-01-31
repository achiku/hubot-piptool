# Description:
#   Utility commands surrounding Hubot uptime.
#
# Commands:
#   hubot pip-check <repo name> - Reply if updates are available
#   hubot pip-review <repo name> - Reply updated requirements

Promise = require 'promise'
{GitHubReqFileParser} = require '../githubtools'
{PyPiTools} = require '../piptools'
github_api_token = process.env.HUBOT_GITHUB_API_TOKEN
success = (process.env.HUBOT_EMOTICON_SUCCESS or "(successful)")
fail = (process.env.HUBOT_EMOTICON_FAIL or "(failed)")

module.exports = (robot) ->
  robot.respond /(pip-check) (.+) (.+) (.+)/i, (msg) ->
    userName = msg.match[2]
    repository = msg.match[3]
    reqFilePath = msg.match[4]
    msg.reply "check #{userName}/#{repository}:#{reqFilePath}"
    pypi = new PyPiTools
    gh = new GitHubReqFileParser userName, repository, github_api_token
    gh.get(reqFilePath).then (libs) ->
      list = (pypi.check(lib) for lib in libs)
      Promise.all(list).then (libs) ->
        output = "library update info \n"
        for lib in libs
          if lib.is_latest
            output += "#{success}\t#{lib.name} #{lib.current_version} = #{lib.latest_version}\n"
          else
            output += "#{fail}\t#{lib.name} #{lib.current_version} < #{lib.latest_version}\n"
        msg.send output
