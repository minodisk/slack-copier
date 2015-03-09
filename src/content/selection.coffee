$ = require 'jquery'

module.exports =
class Selection

  @getSelectedContents: ->
    selection = window.getSelection()
    len = selection.rangeCount
    $contents = $()
    for i in [0...len] by 1
      range = selection.getRangeAt i
      df = range.cloneContents()
      console.log df.parentNode
      for node in df.childNodes
        console.log $(node).parents('body').length
      $contents = $contents.add df.childNodes
    $contents
