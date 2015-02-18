{getSelectedContents} = require './selection.coffee'
{markdown} = require './parser.coffee'

chrome.runtime.sendMessage
  type: 'initialize'

chrome.runtime.onMessage.addListener (req, sender, cb) ->
  cb switch req.type
    when 'markdown'
      markdown getSelectedContents()
    else
      null
