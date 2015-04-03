Promise = require 'promise'
pypi = require 'pypi'
fs = require 'fs'


class @PyPiTools
  constructor: () ->

  check: (lib) ->
    return new Promise (resolve, reject) ->
      client = new pypi.Client
      client.getPackageReleases lib.name, (versions) ->
        latest_version = versions.sort()[versions.length - 1]
        is_latest = if lib.current_version == latest_version then true else false
        resolve {
          name: lib.name,
          current_version: lib.current_version,
          latest_version: latest_version
          is_latest: is_latest
        }
