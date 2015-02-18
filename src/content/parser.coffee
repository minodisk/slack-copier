$ = require 'jquery'

module.exports =
class Parser

  @markdown: ($contents) =>
    token = @parse $contents
    console.log token.toString()
    token.toMarkdown()

  @parse: ($selects) ->
    $messages = $selects.filter('.message').add($selects.find('.message'))
    if $messages.length is 0
      root = new Root
      @tokenizeMessageContent root, $selects.contents()
      root
    else
      @tokenizeMessage $messages.contents()

  @tokenizeMessage: ($contents) ->
    root = new Root
    for el in $contents
      $el = $ el
      $messageContent = $el.find '.message_content'
      continue if $messageContent.length is 0
      root.addToken @tokenizeMessageContent new MessageContent(), $messageContent.contents()
    root

  @tokenizeMessageContent: (parent, $els) ->
    for el, i in $els
      @tokenizePartial parent, el
    parent

  @tokenizePartial: (parent, el) ->
    $el = $ el
    return parent if $el.hasClass 'copyonly'
    switch el.nodeName
      when '#text'
        t = $el.text()
        return parent if t is ''
        text = new Text t
        return parent if text.isEmpty
        parent.addToken text
      when 'BR'
        parent.addToken new Br
      when 'B'
        parent.addToken @tokenizePartial new Bold(), $el.contents()
      when 'I'
        parent.addToken @tokenizePartial new Italic(), $el.contents()
      when 'CODE'
        parent.addToken @tokenizePartial new Code(), $el.contents()
      when 'PRE'
        parent.addToken @tokenizePartial new Pre(), $el.contents()
      when 'DIV'
        if $el.hasClass 'special_formatting_quote'
          parent.addToken @tokenizePartial new Quote(), $el.contents()
        else
          @tokenizePartial parent, $el.contents()
      else
        @tokenizePartial parent, $el.contents()
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
