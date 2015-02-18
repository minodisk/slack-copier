module.exports =
class Selection

  @getNodes: ->
    selection = window.getSelection()
    len = selection.rangeCount
    $selects = $()
    for i in [0...len] by 1
      range = selection.getRangeAt i
      df = range.cloneContents()
      $selects = $selects.add df.childNodes
    $selects
