module.exports =
class Clipboard

  @get: ->
    ta = document.createElement 'textarea'
    document.body.appendChild ta
    ta.select()
    document.execCommand 'paste'
    document.body.removeChild ta
    ta.value

  @set: (text) ->
    ta = document.createElement 'textarea'
    document.body.appendChild ta
    ta.value = text
    ta.select()
    document.execCommand 'copy'
    document.body.removeChild ta
