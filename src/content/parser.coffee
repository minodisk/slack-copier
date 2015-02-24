$ = require 'jquery'

module.exports =
class Parser

  @markdown: (root) =>
    token = @parse root
    return '' unless token?
    # console.log token.toString()
    token.toMarkdown()

  @parse: (el) ->
    $el = $ el
    $messages = $el.filter('.message').add($el.find('.message'))
    if $messages.length is 0
      $messages = $el.parents '.message'
      # console.log $messages.length
      return if $messages.length is 0
      root = @tokenizeMessages $messages
      # console.log 'before filter:', root.toString()
      root.filter $el
      # console.log 'after filter :', root.toString()
      return root

    @tokenizeMessages $messages

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

  @walkContents: (containerToken, $container) ->
    for el in $container.contents()
      @walk containerToken, el
    containerToken

  @walk: (c, el) ->
    $el = $ el
    return if $el.hasClass 'copyonly'

    type = el.nodeName.toLowerCase()
    if type is '#text'
      type = 'text'
    if $el.hasClass('inline_attachment_wrapper') or $el.hasClass('special_formatting_quote')
      type = 'quote'

    switch type
      when 'text'
        c.addToken new Text $el
      when 'br'
        c.addToken new Br
      when 'b'
        c.addToken @walkContents new Bold(), $el
      when 'i'
        c.addToken @walkContents new Italic(), $el
      when 'code'
        c.addToken @walkContents new Code(), $el
      when 'pre'
        c.addToken @walkContents new Pre(), $el
      when 'quote'
        c.addToken @walkContents new Quote(), $el
      else
        @walkContents c, $el


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
  filter: (el) ->
    childTokens = []
    for token in @childTokens
      if token instanceof Chunk
        unless token.isSame el
          continue
        else
          childTokens.push token
      else
        token.filter el
        continue if token.isEmpty()
        childTokens.push token
    @childTokens = childTokens
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

class Wrap extends Container
  pad: ''
  toMarkdown: -> @pad + super() + @pad
class Bold extends Wrap
  pad: '**'
class Italic extends Wrap
  pad: '*'
class Code extends Wrap
  pad: '`'
class Pre extends Wrap
  pad: '```'

class Quote extends Container
  pre: '> '
  br: '\n'
  toMarkdown: ->
    chunks = [@br, @pre]
    for token in @childTokens
      chunks.push token.toMarkdown()
      if token instanceof Br
        chunks.push @pre
    chunks.push @br
    chunks.join ''

class Chunk extends Token
  identifier: ''
  constructor: (el) ->
    super()
    @_$el = $ el
    @_isEmpty = false
  isSame: (el) -> @_$el[0] is el[0]
  isEmpty: -> @_isEmpty
  toString: -> @constructor.name
  toMarkdown: -> @identifier
class Text extends Chunk
  constructor: ->
    super
    identifier = @_$el.text()
    if identifier? and identifier isnt ''
      @identifier = identifier.replace /^\s*(.*?)\s*$/, '$1'
    @_isEmpty = @identifier is ''
  toString: -> "#{@constructor.name}(#{@identifier})"
class Br extends Chunk
  identifier: '\n'
