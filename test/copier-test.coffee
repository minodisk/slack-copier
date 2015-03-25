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

    select = (selector, cb) ->
      $el = $ selector
      $wrapper = $el
        .wrapAll '<div>'
        .parent()
      console.log $el.parent().attr 'class'
      selection.selectAllChildren $wrapper[0]
      cb()
      $el.unwrap()
      console.log '->', $el.parent().attr 'class'

    describe "single message", ->

      it 'should parse normal text with message container', (done) ->
        select '#msg_normal', ->
          markdown().should.match ///^
          \*\*\[.+\]\(https?:\/\/.+\)\*\*\s\*\[\d{2}:\d{2}\]\(https?:\/\/.+\)\*\n
          normal\n
          $///
          done()

      it 'should parse normal text with message content', (done) ->
        select '#msg_normal .message_content', ->
          markdown().should.match ///^
          \*\*\[.+\]\(https?:\/\/.+\)\*\*\s\*\[\d{2}:\d{2}\]\(https?:\/\/.+\)\*\n
          normal\n
          $///
          done()

      it 'should parse bold text with message container', (done) ->
        select '#msg_bold', ->
          markdown().should.match ///^
          \*\*\[.+\]\(https?:\/\/.+\)\*\*\s\*\[\d{2}:\d{2}\]\(https?:\/\/.+\)\*\n
          \*\*bold\*\*\n
          $///
          done()

      it 'should parse bold text with message content', (done) ->
        select '#msg_bold .message_content', ->
          markdown().should.match ///^
          \*\*\[.+\]\(https?:\/\/.+\)\*\*\s\*\[\d{2}:\d{2}\]\(https?:\/\/.+\)\*\n
          \*\*bold\*\*\n
          $///
          done()

      it 'should parse italic text with message container', (done) ->
        select '#msg_italic', ->
          markdown().should.match ///^
          \*\*\[.+\]\(https?:\/\/.+\)\*\*\s\*\[\d{2}:\d{2}\]\(https?:\/\/.+\)\*\n
          \*italic\*\n
          $///
          done()

      it 'should parse italic text with message content', (done) ->
        select '#msg_italic .message_content', ->
          markdown().should.match ///^ \*\*\[.+\]\(https?:\/\/.+\)\*\*\s\*\[\d{2}:\d{2}\]\(https?:\/\/.+\)\*\n
          \*italic\*\n
          $///
          done()

      it 'should parse code text with message container', (done) ->
        select '#msg_code', ->
          markdown().should.match ///^
          \*\*\[.+\]\(https?:\/\/.+\)\*\*\s\*\[\d{2}:\d{2}\]\(https?:\/\/.+\)\*\n
          `code`\n
          $///
          done()

      it 'should parse code text with message content', (done) ->
        select '#msg_code .message_content', ->
          markdown().should.match ///^
          \*\*\[.+\]\(https?:\/\/.+\)\*\*\s\*\[\d{2}:\d{2}\]\(https?:\/\/.+\)\*\n
          `code`\n
          $///
          done()

      it 'should parse preformatted text with message container', (done) ->
        select '#msg_preformatted', ->
          markdown().should.match ///^
          \*\*\[.+\]\(https?:\/\/.+\)\*\*\s\*\[\d{2}:\d{2}\]\(https?:\/\/.+\)\*\n
          \n
          ```\n
          preformatted\n
          text\n
          ```\n
          \n
          $///
          done()

      it 'should parse preformatted text with message content', (done) ->
        select '#msg_preformatted .message_content', ->
          markdown().should.match ///^
          \*\*\[.+\]\(https?:\/\/.+\)\*\*\s\*\[\d{2}:\d{2}\]\(https?:\/\/.+\)\*\n
          \n
          ```\n
          preformatted\n
          text\n
          ```\n
          \n
          $///
          done()

      it 'should parse quoted text with message container', (done) ->
        select '#msg_quoted', ->
          markdown().should.match ///^
          \*\*\[.+\]\(https?:\/\/.+\)\*\*\s\*\[\d{2}:\d{2}\]\(https?:\/\/.+\)\*\n
          >quoted\n
          >text\n
          $///
          done()

      it 'should parse quoted text with message content', (done) ->
        select '#msg_quoted .message_content', ->
          markdown().should.match ///^
          \*\*\[.+\]\(https?:\/\/.+\)\*\*\s\*\[\d{2}:\d{2}\]\(https?:\/\/.+\)\*\n
          >quoted\n
          >text\n
          $///
          done()

      it 'should parse mixed text with message container', (done) ->
        select '#msg_mixed', ->
          markdown().should.match ///^
          \*\*\[.+\]\(https?:\/\/.+\)\*\*\s\*\[\d{2}:\d{2}\]\(https?:\/\/.+\)\*\n
          normal\n
          \*\*bold\*\*\n
          \*italic\*\n
          `code`\n
          \n
          ```\n
          preformatted\n
          text\n
          ```\n
          \n
          >quoted\n
          >text\n
          $///
          done()

    describe "multi messages", ->

      it 'should parse normal and bold texts', (done) ->
        select '#msg_normal, #msg_bold', ->
          markdown().should.match ///^
          \*\*\[.+\]\(https?:\/\/.+\)\*\*\s\*\[\d{2}:\d{2}\]\(https?:\/\/.+\)\*\n
          normal\n
          \*\*\[.+\]\(https?:\/\/.+\)\*\*\s\*\[\d{2}:\d{2}\]\(https?:\/\/.+\)\*\n
          \*\*bold\*\*\n
          $///
          done()
