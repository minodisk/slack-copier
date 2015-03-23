$ = require 'jquery'
{markdown} = require '../src/content/copier.coffee'
tokensHtml = require './fixtures/tokens.html'

describe "copier", ->

  describe ".markdown()", ->

    [selection] = []

    before ->
      $ 'body'
        .html tokensHtml
      selection = document.getSelection()

    beforeEach ->
      selection.removeAllRanges()

    select = (selector) ->
      $ selector
        .each ({}, el) ->
          range = document.createRange()
          range.selectNode el
          selection.addRange range

    describe "single message", ->

      it 'should parse normal text with message container', ->
        select '#msg_normal'
        markdown().should.equal """
        normal
        """

      it 'should parse normal text with message content', ->
        select '#msg_normal .message_content'
        markdown().should.equal """
        normal
        """

      it 'should parse bold text with message container', ->
        select '#msg_bold'
        markdown().should.equal """
        **bold**
        """

      it 'should parse bold text with message content', ->
        select '#msg_bold .message_content'
        markdown().should.equal """
        **bold**
        """

      it 'should parse italic text with message container', ->
        select '#msg_italic'
        markdown().should.equal """
        *italic*
        """

      it 'should parse italic text with message content', ->
        select '#msg_italic .message_content'
        markdown().should.equal """
        *italic*
        """

      it 'should parse code text with message container', ->
        select '#msg_code'
        markdown().should.equal """
        `code`
        """

      it 'should parse code text with message content', ->
        select '#msg_code .message_content'
        markdown().should.equal """
        `code`
        """

      it 'should parse preformatted text with message container', ->
        select '#msg_preformatted'
        markdown().should.equal """
        ```preformatted
        text```

        """

      it 'should parse preformatted text with message content', ->
        select '#msg_preformatted .message_content'
        markdown().should.equal """
        ```preformatted
        text```

        """

      it 'should parse quoted text with message container', ->
        select '#msg_quoted'
        markdown().should.equal """
        > quoted
        > text
        """

      it 'should parse quoted text with message content', ->
        select '#msg_quoted .message_content'
        markdown().should.equal """
        > quoted
        > text
        """

      it 'should parse mixed text with message container', ->
        select '#msg_mixed'
        markdown().should.equal """
        normal
        **bold**
        *italic*
        `code`
        ```preformatted
        text```
        > quoted
        > text
        """

    describe "multi messages", ->

      it 'should parse normal and bold texts', ->
        select '#msg_normal, #msg_bold'
        markdown().should.equal """
        normal
        **bold**
        """
