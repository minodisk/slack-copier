var BowerWebpackPlugin = require('bower-webpack-plugin');

module.exports = {
  entry: './src/main.coffee',
  output: {
    path: './dest',
    filename: 'copier.js'
  },
  module: {
    loaders: [
      { test: /\.coffee$/, loader: 'coffee-loader' }
    ]
  },
  plugins: [
    new BowerWebpackPlugin()
  ]
};
