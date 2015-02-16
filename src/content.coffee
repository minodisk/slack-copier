copier = require './copier.coffee'

chrome.runtime.sendMessage
  type: 'initialize'

chrome.runtime.onMessage.addListener (req, sender, cb) ->
  console.log req, sender
