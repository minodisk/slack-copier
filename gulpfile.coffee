gulp = require 'gulp'
{server: karma} = require 'karma'
{exec} = require 'child_process'
webpack = require 'gulp-webpack'
rename = require 'gulp-rename'
fs = require 'fs'
{inc} = require 'semver'

KARMA_CONF = "#{__dirname}/karma.conf.coffee"
PACKAGE_JSON = 'package.json'
MANIFEST_JSON = 'dest/manifest.json'

increase = (v) -> inc v, 'patch'
BowerWebpackPlugin = require 'bower-webpack-plugin'

gulp.task 'default', ['startTest', 'startBuild']

gulp.task 'startTest', ->
  # karma.start
  #   configFile: KARMA_CONF

gulp.task 'test', ->
  karma.start
    configFile: KARMA_CONF
    singleRun: true

gulp.task 'startBuild', ->
  for {src, renamed} in [
      src: 'src/content.coffee'
      renamed: 'slack-copier-content.js'
    ,
      src: 'src/background.coffee'
      renamed: 'slack-copier-background.js'
  ]
    gulp.src src
      .pipe webpack
        watch: true
        module:
          loaders: [
            test: /\.coffee$/
            loader: 'coffee-loader'
          ]
        plugins: [
          new BowerWebpackPlugin
        ]
      .pipe rename renamed
      .pipe gulp.dest 'dest'

gulp.task 'release', ->
  pkg = JSON.parse fs.readFileSync PACKAGE_JSON
  manifest = JSON.parse fs.readFileSync MANIFEST_JSON
  version = increase pkg.version

  pkg.version = manifest.version = version
  fs.writeFileSync PACKAGE_JSON, JSON.stringify pkg, null, 2
  fs.writeFileSync MANIFEST_JSON, JSON.stringify manifest, null, 2

  exec "git commit -m 'Release v#{version}'"
  exec "git tag v#{version}"
  exec "git push"
