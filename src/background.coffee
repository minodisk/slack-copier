chrome.contextMenus.create
  id: 'markdown'
  type: 'normal'
  title: 'Copy as markdown'
  contexts: [
    'selection'
  ]

chrome.contextMenus.onClicked.addListener (info, tab) ->
  console.log info, tab

console.log 'initizlied'
