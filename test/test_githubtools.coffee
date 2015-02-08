chai = require 'chai'
expect = chai.expect
chai.should()

{GitHubReqFileParser} = require '../src/githubtools'

describe 'GitHubReqFileParser', ->
  t = null
  githubUserName = process.env.HUBOT_GITHUB_USER_NAME
  githubAccessToken = process.env.HUBOT_GITHUB_API_TOKEN
  repositoryName = process.env.HUBOT_GITHUB_REPOSITORY_NAME
  reqFilePath = process.env.HUBOT_REQ_FILE_PATH

  console.log "user: #{githubUserName}"
  console.log "token: #{githubAccessToken}"
  console.log "repo: #{repositoryName}"
  console.log "path: #{reqFilePath}"

  before ->
    t = new GitHubReqFileParser githubUserName, repositoryName, githubAccessToken

  it "get requirements file", ->
    t.get(reqFilePath).then (libs) ->
      for lib in libs
        console.log lib
