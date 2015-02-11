module.exports =
class Copier

  @markdown: ->
    selection = window.getSelection()
    len = selection.rangeCount
    $selects = $()
    for i in [0...len] by 1
      range = selection.getRangeAt i
      df = range.cloneContents()
      $selects = $selects.add df
    texts = @walk $selects.find('.message_content').children()
    texts.join ''

  @walk: ($parts, texts = []) ->
    $parts
      .each (i, el) =>
        console.log i, el, el.nodeName
        $el = $ el
        return if $el.hasClass 'copyonly'
        switch el.nodeName
          when '#text'
            texts.push $el.text()
          when 'B'
            texts.push '**'
            @walk $el.contents(), texts
            texts.push '**'
          when 'I'
            texts.push '*'
            @walk $el.contents(), texts
            texts.push '*'
          else
            @walk $el.children(), texts
    texts
