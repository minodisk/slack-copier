{contextMenus: {create, removeAll, onClicked}} = chrome
Clipboard = require './clipboard.coffee'
console.log Clipboard

chrome.runtime.onInstalled.addListener (details) ->
  Background.initialize()

chrome.runtime.onMessage.addListener (req, sender, cb) ->
  Background[req.type] req, sender, cb

class Background

  @initialize: (req, sender, cb) ->
    removeAll()
    onClicked.removeListener @onClicked

    create
      id: 'markdown'
      type: 'normal'
      title: 'Copy as markdown'
      contexts: [
        'selection'
      ]
    onClicked.addListener @onClicked

    console.log 'initialize'

  @onClicked: (info, tab) ->
    console.log 'onClicked:', info, tab
    switch info.menuItemId
      when 'markdown'
        chrome.tabs.sendMessage tab.id, type: 'markdown', (resp) ->
          console.log 'resp:', resp
          Clipboard.set resp
