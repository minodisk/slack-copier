$ = require 'jquery'

module.exports =
class Parser

  @markdown: ($container) =>
    token = @parse $container
    return '' unless token?
    console.log token.toString()
    token.toMarkdown()

  @parse: ($container) ->
    $messages = $container.find '.message'

    if $messages.length is 0
      $container
        .parents '.message'
        .toArray()
        .reverse()
        .forEach (el) -> $messages = $messages.add el
      return if $messages.length is 0
      root = @tokenizeMessages $messages
      root.filter $container
      return root

    @tokenizeMessages $messages

  @tokenizeMessages: ($messages) ->
    root = new Root
    $messages
      .each (i, message) =>
        root.addToken @tokenizeMessage $ message
    root

  @tokenizeMessage: ($message) ->
    m = new Message
    m.addToken new Sender $message.find '.message_sender'
    m.addToken new Time $message.find '.timestamp'
    $message
      .find '.message_content'
      .each (i, content) =>
        m.addToken @tokenizeContent $ content
    m

  @tokenizeContent: ($content) ->
    mc = new Content
    @walkContents mc, $content
    mc

  @walkContents: (containerToken, $container) ->
    for el in $container.contents()
      @walk containerToken, el
    containerToken

  @walk: (c, el) ->
    $el = $ el
    return if $el.hasClass('copyonly') or $el.hasClass('edited')

    type = el.nodeName.toLowerCase()
    if type is '#text'
      type = 'text'
    if $el.hasClass('inline_attachment_wrapper') or $el.hasClass('special_formatting_quote')
      type = 'quote'

    switch type
      when 'text'
        c.addToken new Text $el
      when 'br'
        c.addToken new Br $el
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
  constructor: (el) -> @$el = $ el
  isEmpty: -> true

class Container extends Token
  pre: ''
  post: ''
  joint: ''
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
    $el = $ el
    childTokens = []
    for token in @childTokens
      if token instanceof Chunk
        if token instanceof Meta or token.isSame $el
          childTokens.push token
        else
          continue
      else
        token.filter $el
        continue if token.isEmpty()
        childTokens.push token
    @childTokens = childTokens
  toString: ->
    "#{@constructor.name}[#{(token.toString() for token in @childTokens).join ', '}]"
  toMarkdown: ->
    (
      for token in @childTokens
        @pre + token.toMarkdown() + @post
    ).join @joint

class Root extends Container
class Message extends Container
  toMarkdown: ->
    md = super()
    if md.slice(-1) isnt '\n'
      md += '\n'
    md
class Content extends Container

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
  # joint: '\n'
  pad: '\n```\n'
  toMarkdown: ->
    super() + '\n'

class Quote extends Container
  pre: '>'
  toMarkdown: ->
    md = ''
    isBreaking = true
    @childTokens.forEach (token) =>
      if isBreaking
        isBreaking = false
        md += @pre
      if token instanceof Br
        isBreaking = true
      md += token.toMarkdown()
    md

class Chunk extends Token
  identifier: ''
  constructor: (el) ->
    super()
    @_$el = $ el
    @_isEmpty = false
  isSame: ($el) ->
    for el in $el
      return true if $.contains(el, @_$el[0]) or el is @_$el[0]
    false
  isEmpty: -> @_isEmpty
  toString: -> @constructor.name
  toMarkdown: -> @identifier

class Br extends Chunk
  identifier: '\n'
class Text extends Chunk
  constructor: ->
    super
    identifier = @_$el.text()
    if identifier? and identifier isnt ''
      @identifier = identifier.replace /^\s*(.*?)\s*$/, '$1'
    @_isEmpty = @identifier is ''
  toString: -> "#{@constructor.name}(#{@identifier})"

class Meta extends Text
  isEmpty: -> false
class Sender extends Meta
  toMarkdown: ->
    url = @_$el.prop 'href'
    "**[#{@identifier}](#{url})** "
class Time extends Meta
  toMarkdown: ->
    url = @_$el.prop 'href'
    "*[#{@identifier}](#{url})*\n"
