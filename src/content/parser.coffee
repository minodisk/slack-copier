$ = require 'jquery'

module.exports =
class Parser

  @markdown: (root) =>
    token = @parse $ root
    console.log token.toString()
    token.toMarkdown()

  @parse: ($contents) ->
    $messages = $contents.filter('.message').add($contents.find('.message'))
    if $messages.length > 0
      @tokenizeMessages $messages
    else
      root = new Root
      @tokenizeMessageContent root, $contents.contents()
      root

  @tokenizeMessages: ($messages) ->
    root = new Root
    $messages.find '.message_content'
      .each (i, messageContent) =>
        root.addToken @tokenizeMessageContent $ messageContent
    root

  @tokenizeMessageContent: ($messageContent) ->
    mc = new MessageContent
    @walkContents mc, $messageContent
    mc

  @walkContents: (container, $container) ->
    c = container
    for el in $container.contents()
      $el = $ el
      continue if $el.hasClass 'copyonly'
      switch el.nodeName
        when '#text'
          c.addToken new Text $el.text()
        when 'BR'
          c.addToken new Br
        when 'B'
          c.addToken @walkContents new Bold(), $el
        when 'I'
          c.addToken @walkContents new Italic(), $el
        when 'CODE'
          c.addToken @walkContents new Code(), $el
        when 'PRE'
          c.addToken @walkContents new Pre(), $el
        when 'DIV'
          if $el.hasClass 'special_formatting_quote'
            c.addToken @walkContents new Quote(), $el
          else
            @walkContents c, $el
        else
          @walkContents c, $el
    c


class Token
  isEmpty: -> true

class Container extends Token
  constructor: ->
    super
    @childTokens = []
  addToken: (token) ->
    return false if !token? or token.isEmpty()
    @childTokens.push token
    true
  addTokens: (tokens) ->
    added = 0
    for token in tokens
      continue unless @addToken token
      added++
    added
  isEmpty: ->
    for token in @childTokens
      return false unless token.isEmpty()
    true
  toString: ->
    "#{@constructor.name}[#{(token.toString() for token in @childTokens).join ', '}]"
  toMarkdown: ->
    (
      for token in @childTokens
        token.toMarkdown()
    ).join ''
class Root extends Container
class Sender extends Container
class Time extends Container
class Message extends Container
class MessageContent extends Container

class PreSuf extends Container
  pre: ''
  suf: ''
  toMarkdown: -> @pre + super() + @suf
class Wrap extends PreSuf
  pad: ''
  constructor: ->
    super
    @pre = @pad
    @suf = @pad
class Bold extends Wrap
  pad: '**'
class Italic extends Wrap
  pad: '*'
class Code extends Wrap
  pad: '`'
class Pre extends Wrap
  pad: '```'
class Oneline extends PreSuf
  suf: '\n'
  toMarkdown: ->
    chunks = [@pre]
    for token in @childTokens
      chunks.push token.toMarkdown()
      if token instanceof Br
        chunks.push @pre
    chunks.push @suf
    chunks.join ''
class Quote extends Oneline
  pre: '> '

class Chunk extends Token
  constructor: -> @_isEmpty = false
  isEmpty: -> @_isEmpty
class Text extends Chunk
  identifier: ''
  constructor: (identifier) ->
    super()
    if identifier? and identifier isnt ''
      @identifier = identifier.replace /^\s*(.*?)\s*$/, '$1'
    @_isEmpty = @identifier is ''
  toString: -> "#{@constructor.name}(#{@identifier})"
  toMarkdown: -> @identifier
class Br extends Text
  identifier: '\n'
  toString: -> @constructor.name
