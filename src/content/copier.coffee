{getSelectedItems} = require './selection.coffee'
{markdown} = require './parser.coffee'

module.exports =

  markdown: -> markdown getSelectedItems()
