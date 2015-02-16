{contextMenus: {create, onClicked}} = chrome

chrome.runtime.onMessage.addListener (req, sender, cb) ->
  Background[req.type] req, sender, cb

class Background

  @initialize: (req, sender, cb) ->
    create
      id: 'markdown'
      type: 'normal'
      title: 'Copy as markdown'
      contexts: [
        'selection'
      ]
    onClicked.addListener @onClicked
    console.log 'initialized'

  @onClicked: (info, tab) ->
      console.log info, tab
