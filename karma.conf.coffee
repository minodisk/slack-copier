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
      'main.coffee': ['browserify']
      'test/**/*-test.coffee': [ 'browserify' ]
    browserify:
      extensions: ['.coffee']
      transform: ['coffeeify']
      watch: true
      debug: true
    reporters: [ 'progress' ]
    port: 9876
    colors: true
    logLevel: config.LOG_INFO
    autoWatch: true
    browsers: [
      'PhantomJS'
      'Chrome'
    ]
    singleRun: false
