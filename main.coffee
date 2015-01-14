class Clipboard

  get: ->
    ta = document.createElement 'textarea'
    document.body.appendChild ta
    ta.select()
    document.execCommand 'paste'
    document.body.removeChild ta
    ta.value

  set: (text) ->
    ta = document.createElement 'textarea'
    document.body.appendChild ta
    ta.value = text
    ta.select()
    document.execCommand 'copy'
    document.body.removeChild ta

format = (text) ->
  text
    .replace /\n\-{5} \w+ \d+\w+, \d+ \-{5}\n/mg, ''
    .replace /^(\w+)\s+(\[\d{2}:\d{2}\])\s*$/mg, '**$1** *$2*'

document.addEventListener 'copy', (e) ->
  setTimeout ->
    c = new Clipboard
    text = c.get()
    console.log format text
    # c.set format text
  , 0
