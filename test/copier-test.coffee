$ = require 'jquery'
Copier = require '../src/copier.coffee'
styles = require './styles.coffee'

describe 'Copier', ->

  [$body, selection] = []

  before ->
    $body = $ 'body'
    selection = window.getSelection()

  beforeEach ->
    $body.empty()

  describe '.markdown()', ->

    describe 'style', ->

      describe 'singleline', ->

        {normal, bold, italics, code, preformatted, quote} = styles.singleline

        it 'should format normal', ->
          $body.html normal
          selection.selectAllChildren $body[0]
          Copier.markdown().should.equal 'normal'

        it 'should format bold', ->
          $body.html bold
          selection.selectAllChildren $body[0]
          Copier.markdown().should.equal '**bold**'

        it 'should format italics', ->
          $body.html italics
          selection.selectAllChildren $body[0]
          Copier.markdown().should.equal '*italics*'

        it 'should format code', ->
          $body.html code
          selection.selectAllChildren $body[0]
          Copier.markdown().should.equal '`code`'

        it 'should format preformatted', ->
          $body.html preformatted
          selection.selectAllChildren $body[0]
          Copier.markdown().should.equal '```preformatted```'

        it 'should format quote', ->
          $body.html quote
          selection.selectAllChildren $body[0]
          Copier.markdown().should.equal '>quote'

      describe 'multiline', ->

        {normal, preformatted, quote} = styles.multiline

        it 'should format normal', ->
          $body.html normal
          selection.selectAllChildren $body[0]
          Copier.markdown().should.equal """
            normal
            text
            """

        it 'should format preformatted code', ->
          $body.html preformatted
          selection.selectAllChildren $body[0]
          Copier.markdown().should.equal """
            ```preformatted
            code```
            """

        it 'should format quote', ->
          $body.html quote
          selection.selectAllChildren $body[0]
          Copier.markdown().should.equal """
            >quoted
            >text
            """
