Copier = require '../copier'
{bold, italics} = require './example'

describe 'copier', ->

  describe '.markdown', ->

    it 'should format bold', ->
      $ 'body'
        .empty()
        .html bold
      selection = window.getSelection()
      selection.selectAllChildren $('body')[0]
      Copier.markdown()
        .should.equal '**bold**'

    it 'should format italics', ->
      $ 'body'
        .empty()
        .html italics
      selection = window.getSelection()
      selection.selectAllChildren $('body')[0]
      Copier.markdown()
        .should.equal '*italics*'
