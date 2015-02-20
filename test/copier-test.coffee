$ = require 'jquery'
{markdown} = require '../src/content/parser.coffee'
styles = require './styles.coffee'

describe 'Copier', ->

  describe '.markdown()', ->

    filterTexts = (el) ->
      filter = (i, el) -> el.nodeName is '#text'
      $c = $(el).find('.message_content')
      $texts = $()
      while $c.contents().length
        $c = $c.contents()
        $texts = $texts.add $c.filter(filter)
      # $texts = $messageContents.contents().filter(filter).add $messageContents.find('.content').contents().filter(filter)
      for text, i in $texts
        console.log i, text
      $texts

    describe 'singleline', ->

      {normal, bold, italics, code, preformatted, quote} = styles.singleline

      it 'should format normal', ->
        el = normal
        markdown(el).should.equal 'normal'
        for text, i in filterTexts el
          markdown(text).should.equal if i is 0
            'normal'
          else
            ''

      it 'should format bold', ->
        el = bold
        markdown(el).should.equal '**bold**'
        for text, i in filterTexts el
          markdown(text).should.equal if i is 2
            '**bold**'
          else
            ''

      it 'should format italics', ->
        el = italics
        markdown(el).should.equal '*italics*'
        for text, i in filterTexts el
          markdown(text).should.equal if i is 2
            '*italics*'
          else
            ''

      it 'should format code', ->
        el = code
        markdown(el).should.equal '`code`'
        for text in filterTexts el
          markdown(text).should.equal '`code`'

      it 'should format preformatted', ->
        el = preformatted
        markdown(el).should.equal '```preformatted```'
        for text, i in filterTexts el
          markdown(text).should.equal if i is 2
            '```preformatted```'
          else
            ''

      it 'should format quote', ->
        el = quote
        markdown(el).should.equal """
          > quote

          """
        for text, i in filterTexts el
          markdown(text).should.equal if i is 2
            """
            > quote

            """
          else
            ''

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
