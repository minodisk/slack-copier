istanbul = require 'browserify-istanbul'

module.exports = (config) ->
  config.set
    basePath: ''
    frameworks: [
      'browserify'
      'mocha'
      'chai'
    ]
    files: [
      'bower_components/jquery/dist/jquery.js'
      'test/**/*-test.coffee'
    ]
    exclude: []
    preprocessors:
      # 'main.coffee': ['browserify']
      'test/**/*-test.coffee': [ 'browserify' ]
    browserify:
      extensions: ['.coffee']
      transform: [
        'coffeeify'
        # istanbul #ignore: ['node_modules/**', 'test/**']
      ]
      watch: true
      debug: true
    reporters: [
      'spec'
      # 'coverage'
    ]
    # coverageReporter:
    #   type: 'lcov'
    #   dir: 'coverage'
    #   subdir: (browser) -> browser.toLowerCase().split(/[ /-]/)[0]
    port: 9876
    colors: true
    logLevel: config.LOG_INFO
    autoWatch: true
    browsers: [
      'PhantomJS'
      # 'Chrome'
    ]
    singleRun: false
