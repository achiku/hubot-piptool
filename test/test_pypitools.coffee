chai = require 'chai'
expect = chai.expect
chai.should()

Promise = require 'promise'
{PyPiTools} = require '../src/piptools'

describe 'PyPiTools', ->
  t = null

  before ->
    t = new PyPiTools

  libs = [
    { name: 'celery', current_version: '3.1.17' },
    { name: 'Django', current_version: '1.6.10' },
    { name: 'django-celery', current_version: '3.1.16' },
    { name: 'django-crispy-forms', current_version: '1.4.0' },
    { name: 'django-extensions', current_version: '1.4.9' },
    { name: 'django-grappelli', current_version: '2.6.3' },
    { name: 'Fabric', current_version: '1.8.0' },
    { name: 'fabtools', current_version: '0.15.0' },
  ]

  it "get latest versions", ->
    array = (t.check(lib) for lib in libs)
    Promise.all(array)
      .then (libs) ->
        for lib in libs
          console.log lib
