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
      $container = $ range.commonAncestorContainer
      # for node in df.childNodes
      #   console.log selection.containsNode node
      console.log $container.length
      $selecteds = @each selection, $container[0]
      console.log $selecteds.length
      $contents = $contents.add df.childNodes
    $contents

  @each: (selection, el, $selecteds = $()) ->
    return $selecteds.add el if selection.containsNode el
    $(el).contents().each (i, el) -> $selecteds = @each selection, el, $selecteds
    $selecteds
