$ = require 'jquery'
{markdown} = require '../src/content/parser.coffee'
styles = require './styles.coffee'

describe 'Copier', ->

  describe '.markdown()', ->

    describe 'singleline', ->

      {normal, bold, italics, code, preformatted, quote} = styles.singleline

      it 'should format normal', ->
        markdown(normal).should.equal 'normal'
        $c = $(normal).find('.message_content').contents().filter (i, el) -> true
        markdown($c).should.equal 'normal'

      it 'should format bold', ->
        markdown(bold).should.equal '**bold**'

      it 'should format italics', ->
        markdown(italics).should.equal '*italics*'

      it 'should format code', ->
        markdown(code).should.equal '`code`'

      it 'should format preformatted', ->
        markdown(preformatted).should.equal '```preformatted```'

      it 'should format quote', ->
        markdown(quote).should.equal """
          > quote

          """

    describe 'multiline', ->

      {normal, preformatted, quote} = styles.multiline

      it 'should format normal', ->
        markdown(normal).should.equal """
          normal
          text
          """

      it 'should format preformatted code', ->
        markdown(preformatted).should.equal """
          ```preformatted
          code```
          """

      it 'should format quote', ->
        markdown(quote).should.equal """
          > quoted
          > text

          """

    describe 'complex', ->

      {quoteAndNormal} = require './sample-complex.coffee'

      it 'should formate quote and normal', ->
        markdown(quoteAndNormal).should.equal """
          > quoted
          normal
          """
