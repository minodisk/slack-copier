copier = require './copier.coffee'

chrome.runtime.sendMessage
  type: 'initialize'

chrome.runtime.onMessage.addListener (req, sender, cb) ->
  console.log md = copier.markdown()
  # cb copier.markdown()
  cb md
