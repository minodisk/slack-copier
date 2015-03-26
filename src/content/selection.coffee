$ = require 'jquery'

module.exports =
class Selection

  @getSelectedItems: =>
    selection = window.getSelection()
    len = selection.rangeCount
    $items = $()
    for i in [0...len] by 1
      range = selection.getRangeAt i
      $items = $items.add @walk selection, range.commonAncestorContainer
    $items

  @walk: (selection, parent) =>
    $parent = $ parent
    $items = $()
    if selection.containsNode parent
      return $items.add $parent
    $parent
      .contents()
      .each (i, content) =>
        $items = $items.add @walk selection, content
    $items
