pypi = require 'pypi'
fs = require 'fs'


class PyPiTools
  constructor: () ->
    @client = new pypi.Client

  check: (targetReqFile) =>
    console.log "check updates: #{@targetReqFile}"
    @_parseRequirements targetReqFile

  review: () =>
    console.log "review updates: #{@targetReqFile}"

  _fetchRequirementsInfo: (lib) =>
    @client.getPackageReleases lib.name, (versions) ->
      latest_version = versions.sort()[versions.length - 1]
      if lib.current_version != latest_version
        console.log "[x] #{lib.name}: #{lib.current_version} -> #{latest_version}"
      else
        console.log "#{lib.name}: #{lib.current_version} = #{latest_version}"

  _parseRequirements: (targetReqFile) =>
    libs = fs.readFileSync targetReqFile
      .toString()
      .split('\n')
    current_packages = []
    for lib in libs
      if lib != '' and not lib.match('^-r') and not lib.match('^#')
        [name, current_version] = lib.split('==')
        current_packages.push {name: name, current_version: current_version}

    current_packages.map(@_fetchRequirementsInfo)


tool = new PyPiTools
tool.check '../requirements/development.txt'
