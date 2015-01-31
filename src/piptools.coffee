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


# tool = new @PyPiTools
# libs = [
#   { name: 'celery', current_version: '3.1.17' },
#   { name: 'Django', current_version: '1.6.10' },
#   { name: 'django-celery', current_version: '3.1.16' },
#   { name: 'django-crispy-forms', current_version: '1.4.0' },
#   { name: 'django-extensions', current_version: '1.4.9' },
#   { name: 'django-grappelli', current_version: '2.6.3' },
#   { name: 'Fabric', current_version: '1.8.0' },
#   { name: 'fabtools', current_version: '0.15.0' },
# ]
# array = (tool.check(lib) for lib in libs)
# Promise.all(array)
#   .then (libs) ->
#     for lib in libs
#       console.log lib
