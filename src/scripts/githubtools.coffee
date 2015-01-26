GitHubApi = require 'github'
Base64 = require 'base64'

class @GitHubReqFileParser
  constructor: (@userName, @repositoryName, @github_api_token) ->
    @client = new GitHubApi(
      version: "3.0.0"
      debug: false
      protocol: "https"
      timeout: 5000
    )
    @client.authenticate(
      type: 'oauth'
      token: @github_api_token
    )

  _createPackageList: (callback) ->
    return (err, res) ->
      current_packages = []
      for lib in Base64.decode(res.content).split('\n')
        if lib != '' and not lib.match('^-r') and not lib.match('^#')
          [name, current_version] = lib.split('==')
          current_packages.push {name: name, current_version: current_version}
      callback(current_packages)

  fetch: (reqFilePath, callback) =>
    @client.repos.getContent(
      user: @userName
      repo: @repositoryName
      path: reqFilePath
    , @_createPackageList(callback)
    )


# p = new @GitHubReqFileParser 'clo-admin', 'kanmu'
# p.fetch 'requirements/common.txt', (current_packages) -> console.log current_packages
