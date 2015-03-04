{getSelectedContents} = require '../src/content/selection.coffee'
$ = require 'jquery'

describe 'selection', ->

  describe '.getSelectedContents()', ->

    before ->
      html = require './fixtures/style.html'
      $ 'body'
        .html html

    it 'should ', ->
      console.log $('body').html()
