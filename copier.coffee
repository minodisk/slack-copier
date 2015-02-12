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
    @parse $selects

  @parse: ($selects) ->
    $messages = $selects.filter('.message').add($selects.find('.message'))
    if $messages.length is 0
      $contents = $selects
    else
      $contents = $messages.contents()
    (
      for token in @tokenize $contents
        token.toMarkdown()
    ).join ''

  @tokenize: ($contents) ->
    tokens = []
    for el in $contents
      $el = $ el
      @tokenizeMessageContent $el.find('.message_content').contents(), tokens
    tokens

  @tokenizeMessageContent: ($els) ->
    tokens = []
    $els.each (i, el) =>
      $el = $ el
      return if $el.hasClass 'copyonly'
      switch $el[0].nodeName
        when '#text'
          tokens.push new Text $el.text()
        when 'BR'
          tokens.push new Br
        when 'B'
          tokens.push new Bold @tokenizeMessageContent $el.contents()
        when 'I'
          tokens.push new Italic @tokenizeMessageContent $el.contents()
        when 'CODE'
          tokens.push new Code @tokenizeMessageContent $el.contents()
        when 'PRE'
          tokens.push new Pre @tokenizeMessageContent $el.contents()
        when 'DIV'
          if $el.hasClass 'special_formatting_quote'
            tokens.push new Quote @tokenizeMessageContent $el.contents()
          else
            tokens.concat @tokenizeMessageContent $el.contents()
        else
          tokens.concat @tokenizeMessageContent $el.contents()
    tokens

class Token
  childTokens: []
  addTokens: (tokens) -> @childTokens = @childTokens.concat tokens
  toMarkdown: ->
    (
      for token in childTokens
        token.toMarkdown()
    ).join ''

class Sender extends Token
class Time extends Token

class Text extends Token
  identifier: ''
  constructor: (identifier) ->
    # console.log identifier, '->', identifier.replace /^\s*(.*?)\s*$/, '$1'
    super()
    if identifier? and identifier isnt ''
      @identifier = identifier.replace /^\s*(.*?)\s*$/, '$1'
  toMarkdown: -> @identifier
class Br extends Text
  identifier: '\n'

class Style extends Token
  prefix: ''
  postfix: ''
  toMarkdown: -> @prefix + super() + @postfix
class Bold extends Style
  prefix: '**'
  postfix: '**'
class Italic extends Style
  prefix: '*'
  postfix: '*'
class Code extends Style
  prefix: '`'
  postfix: '`'
class Pre extends Style
  prefix: '```'
  postfix: '```'
class Quote extends Style
  prefix: '>'
