{contextMenus: {create, onClicked}} = chrome

chrome.runtime.onInstalled.addListener (details) ->
  Background.initialize()

chrome.runtime.onMessage.addListener (req, sender, cb) ->
  Background[req.type] req, sender, cb

class Background

  @initialized: false

  @initialize: (req, sender, cb) ->
    return if @initialized
    @initialized = true
    create
      id: 'markdown'
      type: 'normal'
      title: 'Copy as markdown'
      contexts: [
        'selection'
      ]
    onClicked.addListener @onClicked

  @onClicked: (info, tab) ->
    console.log 'onClicked:', info, tab
    chrome.tabs.sendMessage tab.id, type: info.menuItemId, (resp) ->
      console.log 'resp:', resp
