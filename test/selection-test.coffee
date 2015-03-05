{getSelectedContents} = require '../src/content/selection.coffee'
$ = require 'jquery'
copier = require '../src/content/copier.coffee'

describe 'copier', ->

  describe '.markdown()', ->

    [selection] = []

    before ->
      html = require './fixtures/style.html'
      $ 'body'
        .html html
      selection = document.getSelection()

    beforeEach ->
      selection.removeAllRanges()

    it 'should parse normal text', ->
      range = document.createRange()
      range.selectNode $('#msg_normal')[0]
      selection.addRange range
      copier.markdown().should.equal """
      normal
      """
