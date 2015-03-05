copier = require './copier.coffee'

chrome.runtime.sendMessage
  type: 'initialize'

chrome.runtime.onMessage.addListener (req, sender, cb) ->
  func = copier[req.type]
  cb if func? then func() else null
