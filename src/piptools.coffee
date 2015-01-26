pypi = require 'pypi'
fs = require 'fs'


class @PyPiTools
  constructor: () ->
    @client = new pypi.Client

  check: (lib, callback) =>
    @_checkUpdate lib, callback

  _checkUpdate: (lib, callback) =>
    @client.getPackageReleases lib.name, (versions) ->
      latest_version = versions.sort()[versions.length - 1]
      is_latest = if lib.current_version == latest_version then true else false
      callback({
        name: lib.name,
        current_version: lib.current_version,
        latest_version: latest_version
        is_latest: is_latest
      })


# tool = new @PyPiTools
# tool.check {name: 'awscli', current_version: '1.6.10'}, (lib) ->
#   console.log lib
#   if not lib.is_latest
#     console.log "[x] #{lib.name}: #{lib.current_version} -> #{lib.latest_version}"
#   else
#     console.log "#{lib.name}: #{lib.current_version} = #{lib.latest_version}"
