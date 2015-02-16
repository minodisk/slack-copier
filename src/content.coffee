copier = require './copier.coffee'

chrome.runtime.sendMessage
  type: 'initialize'
