GitHubApi = require 'github'
Base64 = require 'Base64'


class GitHubReqFileParser
  constructor: (@repositoryName, @user) ->
    @token = process.env.GITHUB_API_TOKEN
    @client = new GitHubApi(
      version: "3.0.0"
      debug: false
      protocol: "https"
      timeout: 5000
    )
    @client.authenticate(
      type: 'oauth'
      token: @token
    )

  _func: (err, res) ->
    current_packages = []
    for lib in Base64.decode(res.content).split('\n')
      if lib != '' and not lib.match('^-r') and not lib.match('^#')
        [name, current_version] = lib.split('==')
        current_packages.push {name: name, current_version: current_version}
        console.log name, current_version

  fetch: (reqFilePath) =>
    @client.repos.getContent(
      user: @user
      repo: @repositoryName
      path: reqFilePath
    , @_func
    )


# p = new GitHubReqFileParser 'clo-admin', 'kanmu'
# p.fetch 'requirements/development.txt'
