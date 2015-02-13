$ = require 'jquery'

module.exports =
class Copier

  @markdown: ->
    selection = window.getSelection()
    len = selection.rangeCount
    $selects = $()
    for i in [0...len] by 1
      range = selection.getRangeAt i
      df = range.cloneContents()
      $selects = $selects.add df
    token = @parse $selects
    console.log token.toString()
    token.toMarkdown()

  @parse: ($selects) ->
    $messages = $selects.filter('.message').add($selects.find('.message'))
    if $messages.length is 0
      $contents = $selects
    else
      $contents = $messages.contents()
    @tokenize $contents

  @tokenize: ($contents) ->
    root = new Root
    for el in $contents
      $el = $ el
      root.addToken @tokenizeMessageContent new MessageContent(), $el.find('.message_content').contents()
    root

  @tokenizeMessageContent: (parent, $els) ->
    for el, i in $els
      $el = $ el
      continue if $el.hasClass 'copyonly'
      switch $el[0].nodeName
        when '#text'
          t = $el.text()
          continue if t is ''
          text = new Text t
          continue if text.isEmpty
          parent.addToken text
        when 'BR'
          parent.addToken new Br
        when 'B'
          parent.addToken @tokenizeMessageContent new Bold(), $el.contents()
        when 'I'
          parent.addToken @tokenizeMessageContent new Italic(), $el.contents()
        when 'CODE'
          parent.addToken @tokenizeMessageContent new Code(), $el.contents()
        when 'PRE'
          parent.addToken @tokenizeMessageContent new Pre(), $el.contents()
        when 'DIV'
          if $el.hasClass 'special_formatting_quote'
            parent.addToken @tokenizeMessageContent new Quote(), $el.contents()
          else
            @tokenizeMessageContent parent, $el.contents()
        else
          @tokenizeMessageContent parent, $el.contents()
    parent

class Token
  constructor: ->
    @childTokens = []
  addToken: (token) ->
    @childTokens.push token
    @
  addTokens: (tokens) ->
    @childTokens = @childTokens.concat tokens
    @
  toString: ->
    "#{@constructor.name}[#{(token.toString() for token in @childTokens).join ', '}]"
  toMarkdown: ->
    (
      for token in @childTokens
        token.toMarkdown()
    ).join ''

class Root extends Token
class Sender extends Token
class Time extends Token
class MessageContent extends Token

class Text extends Token
  identifier: ''
  constructor: (identifier) ->
    # console.log identifier, '->', identifier.replace /^\s*(.*?)\s*$/, '$1'
    super()
    if identifier? and identifier isnt ''
      @identifier = identifier.replace /^\s*(.*?)\s*$/, '$1'
    @isEmpty = @identifier is ''
  toString: -> "#{@constructor.name}(#{@identifier})"
  toMarkdown: -> @identifier
class Br extends Text
  identifier: '\n'
  toString: -> @constructor.name

class Style extends Token
  pad: ''
class WrapStyle extends Style
  toMarkdown: -> @pad + super() + @pad
class PrefixStyle extends Style
  toMarkdown: ->
    chunks = [@pad]
    for token in @childTokens
      chunks.push token.toMarkdown()
      if token instanceof Br
        chunks.push @pad
    chunks.join ''
class Bold extends WrapStyle
  pad: '**'
class Italic extends WrapStyle
  pad: '*'
class Code extends WrapStyle
  pad: '`'
class Pre extends WrapStyle
  pad: '```'
class Quote extends PrefixStyle
  pad: '>'
