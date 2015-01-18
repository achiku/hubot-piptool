gulp = require 'gulp'
coffee = require 'gulp-coffee'
watch = require 'gulp-watch'
plumber = require 'gulp-plumber'
notify = require 'gulp-notify'
mocha = require 'gulp-mocha'
del = require 'del'

gulp.task 'coffee', ->
  gulp
    .src 'src/**/*.coffee'
    .pipe plumber(errorHandler: notify.onError '<%= error.message %>')
    .pipe coffee()
    .pipe gulp.dest './dest'

gulp.task 'watch', ->
  gulp.watch('src/**/*.coffee', ['coffee'])

gulp.task 'clean', ->
  del 'dest/**/*.js'

gulp.task 'test', ->
  gulp
    .src ['test/**/*.coffee']
    .pipe mocha {reporter: 'spec'}
