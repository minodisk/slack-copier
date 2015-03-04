BowerWebpackPlugin = require 'bower-webpack-plugin'

module.exports = (config) ->
  config.set
    basePath: ''
    frameworks: [
      'mocha'
      'chai'
    ]
    files: [
      # 'test/fixtures/*.html'
      'test/**/*-test.coffee'
    ]
    exclude: []
    preprocessors:
      'test/**/*-test.coffee': [
        'webpack'
        'sourcemap'
      ]
    webpack:
      module:
        loaders: [
            test: /\.coffee$/
            loader: 'coffee'
          ,
            test: /\.html$/
            loader: 'html'
          ,
            test: /\.(:?jpg|png|gif)$/
            loader: 'file'
        ]
        postLoaders: [
          test: /\.coffee$/
          exclude: /(test|node_modules|bower_components)\//
          loader: 'istanbul-instrumenter'
        ]
      plugins: [
        new BowerWebpackPlugin
      ]
    reporters: [
      'spec'
      'coverage'
    ]
    coverageReporter:
      type: 'lcov'
      dir: 'coverage'
      subdir: (browser) -> browser.toLowerCase().split(/[ /-]/)[0]
    port: 9876
    colors: true
    logLevel: config.LOG_INFO
    autoWatch: true
    browsers: [
      'PhantomJS'
      # 'Chrome'
    ]
    singleRun: false
