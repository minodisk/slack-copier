$ = require 'jquery'

module.exports =
class Selection

  @getSelectedContents: =>
    selection = window.getSelection()
    len = selection.rangeCount
    $contents = $()
    for i in [0...len] by 1
      range = selection.getRangeAt i
      df = range.cloneContents()
      $selecteds = @each selection, range.commonAncestorContainer
    $selecteds

  @each: (selection, el) =>
    $el = $ el
    return $el if selection.containsNode el
    $selecteds = $()
    $el.contents().each (i, el) => $selecteds = $selecteds.add @each selection, el
    $selecteds
