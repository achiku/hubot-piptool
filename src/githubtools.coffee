GitHubApi = require 'github'
Promise = require 'promise'

class @GitHubReqFileParser
  constructor: (@userName, @repositoryName, @github_api_token, debug=false) ->
    @client = new GitHubApi(
      version: "3.0.0"
      debug: debug
      protocol: "https"
      timeout: 5000
    )
    @client.authenticate(
      type: 'oauth'
      token: @github_api_token
    )
    @githubGetContent = Promise.denodeify(@client.repos.getContent)

  get: (reqFilePath) ->
    params = {user: @userName, repo: @repositoryName, path:reqFilePath}
    @githubGetContent(params).then(
      (res) ->
        current_packages = []
        for lib in (new Buffer(res.content, 'base64')).toString().split('\n')
          if lib != '' and not lib.match('^-r') and not lib.match('^#')
            [name, current_version] = lib.split('==')
            current_packages.push {name: name, current_version: current_version}
        return current_packages
    ).catch(
      (err) ->
        console.log err
    )
