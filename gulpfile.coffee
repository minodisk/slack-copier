gulp = require 'gulp'
{exec} = require 'child_process'
webpack = require 'webpack'
rename = require 'gulp-rename'
{server: karma} = require 'karma'
BowerWebpackPlugin = require 'bower-webpack-plugin'
fs = require 'fs'
{join} = require 'path'
{inc} = require 'semver'

KARMA_CONF = "#{__dirname}/karma.conf.coffee"
PACKAGE_JSON = 'package.json'
MANIFEST_JSON = 'dest/manifest.json'

increase = (v) -> inc v, 'patch'

gulp.task 'default', ['startTest', 'startBuild']

gulp.task 'startTest', (done) ->
  karma.start
    configFile: KARMA_CONF
    singleRun: false
  , done
  return

gulp.task 'test', (done) ->
  karma.start
    configFile: KARMA_CONF
    singleRun: true
  , done
  return

gulp.task 'startBuild', ->
  webpack
    watch: true
    colors: true
    entry:
      content: './src/content/main'
      background: './src/background/main'
    output:
      path: join __dirname, 'dest'
      filename: 'slack-copier-[name].js'
    resolve:
      extensions: ['', '.js', '.coffee']
    module:
      loaders: [
        test: /\.coffee$/
        loader: 'coffee-loader'
      ]
    plugins: [
      new BowerWebpackPlugin
    ]
  , (err, stats) ->
    throw new PluginError 'webpack', err if err?
    console.log stats.toString
      colors: true
      chunkModules: false
  return

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
