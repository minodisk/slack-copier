Copier = require '../copier'
{bold, italics, code, preformatted, quote} = require './example'

describe 'copier', ->

  [$body] = []

  before ->
    $body = $ 'body'

  beforeEach ->
    $body.empty()

  describe '.markdown', ->

    it 'should format bold', ->
      $body.html bold
      window.getSelection().selectAllChildren $('body')[0]
      Copier.markdown().should.equal '**bold**'

    it 'should format italics', ->
      $body.html italics
      window.getSelection().selectAllChildren $('body')[0]
      Copier.markdown().should.equal '*italics*'

    it 'should format code', ->
      $body.html code
      window.getSelection().selectAllChildren $('body')[0]
      Copier.markdown().should.equal '`code`'

    it 'should format preformatted', ->
      $body.html preformatted
      window.getSelection().selectAllChildren $('body')[0]
      Copier.markdown().should.equal '```preformatted```'

    it 'should format quote', ->
      $body.html quote
      window.getSelection().selectAllChildren $('body')[0]
      Copier.markdown().should.equal '>quote'
