# $ = require 'jquery'
# {markdown} = require '../src/content/parser.coffee'
# styles = require './styles.coffee'
#
# describe 'parser', ->
#
#   describe '.markdown()', ->
#
#     findTexts = (el) ->
#       filterNotCopyonly = (i, el) -> !$(el).hasClass 'copyonly'
#       filterText = (i, el) -> el.nodeName is '#text'
#       $c = $(el).find('.message_content')
#       $texts = $()
#       while $c.contents().length
#         $c = $c.contents().filter filterNotCopyonly
#         $texts = $texts.add $c.filter filterText
#       $texts
#
#     describe 'singleline', ->
#
#       {normal, bold, italics, code, preformatted, quote} = styles.singleline
#
#       it 'should format normal', ->
#         el = normal
#         markdown(el).should.equal 'normal'
#         for text, i in findTexts el
#           markdown(text).should.equal if i is 0
#             'normal'
#           else
#             ''
#
#       it 'should format bold', ->
#         el = bold
#         markdown(el).should.equal '**bold**'
#         for text, i in findTexts el
#           markdown(text).should.equal if i is 1
#             '**bold**'
#           else
#             ''
#
#       it 'should format italics', ->
#         el = italics
#         markdown(el).should.equal '*italics*'
#         for text, i in findTexts el
#           markdown(text).should.equal if i is 1
#             '*italics*'
#           else
#             ''
#
#       it 'should format code', ->
#         el = code
#         markdown(el).should.equal '`code`'
#         for text, i in findTexts el
#           markdown(text).should.equal if i is 1
#            '`code`'
#           else
#             ''
#
#       it 'should format preformatted', ->
#         el = preformatted
#         markdown(el).should.equal '```preformatted```'
#         for text, i in findTexts el
#           markdown(text).should.equal if i is 1
#             '```preformatted```'
#           else
#             ''
#
#       it 'should format quote', ->
#         el = quote
#         markdown(el).should.equal """
#
#           > quote
#
#           """
#         for text, i in findTexts el
#           markdown(text).should.equal if i is 1
#             """
#
#             > quote
#
#             """
#           else
#             ''
#
#     describe 'multiline', ->
#
#       {normal, preformatted, quote} = styles.multiline
#
#       it 'should format normal', ->
#         markdown(normal).should.equal """
#           normal
#           text
#           """
#
#       it 'should format preformatted code', ->
#         markdown(preformatted).should.equal """
#           ```preformatted
#           code```
#           """
#
#       it 'should format quote', ->
#         markdown(quote).should.equal """
#
#           > quoted
#           > text
#
#           """
#
#     describe 'complex', ->
#
#       {quoteAndNormal, bot} = require './sample-complex.coffee'
#
#       it 'should format quote and normal', ->
#         markdown(quoteAndNormal).should.equal """
#
#           > quoted
#           normal
#           """
#
#       it 'should format bot', ->
#         markdown(bot).should.equal """
#           abc
#           > def
#
#           """
#
#         markdown($(bot).find('.inline_attachment').contents()).should.equal """
#           abc
#           > def
#
#           """
#
