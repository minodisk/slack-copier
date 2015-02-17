copier = require './copier.coffee'

chrome.runtime.sendMessage
  type: 'initialize'

chrome.runtime.onMessage.addListener (req, sender, cb) ->
  cb copier.markdown()
