$ = require 'jquery'

module.exports =
class Selection

  @getSelectedContents: =>
    selection = window.getSelection()
    len = selection.rangeCount
    $contents = $()
    for i in [0...len] by 1
      range = selection.getRangeAt i
      $contents = $contents.add @walk selection, range.commonAncestorContainer
    $contents

  @walk: (selection, container) =>
    $container = $ container
    return $container if selection.containsNode container
    $contents = $()
    $container.contents().each (i, content) =>
      $contents = $contents.add @walk selection, content
    $contents
