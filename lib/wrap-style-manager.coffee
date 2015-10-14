{CompositeDisposable} = require 'atom'
TokenizedLine = require 'src/tokenized-line'
React = require 'react'
ReactDom = require 'react-dom'
WrapStyleSandbox = require './wrap-style-sandbox'

module.exports =
class WrapStyleManager
  constructor: ->
    @originalFindWrapColumn = null
    @sandbox = null
    @memoryMap = new Map

    # Create root element
    @element = document.createElement 'div'
    @element.classList.add 'wrap-style'
    @element.style.position = 'absolute'
    @element.style.visibility = 'hidden'
    @element.style.fontFamily = "Menlo, Consolas, 'DejaVu Sans Mono', monospace"
    atom.views.getView atom.workspace
      .appendChild @element

    # add ovserver
    @subscriptions = new CompositeDisposable
    [
      'editor.fontSize'
      'editor.fontFamily'
      'wrap-style.style.whiteSpace'
      'wrap-style.style.lineBreak'
      'wrap-style.style.wordBreak'
      # 'wrap-style.style.hyphens'
      'wrap-style.style.overflowWrap'
      # 'wrap-style.lang'
      'wrap-style.strictMode'
    ].forEach (name) =>
      @subscriptions.add atom.config.observe name, (value) =>
        @renderSandbox()
    @subscriptions.add atom.workspace.observeActivePaneItem (item) =>
      @clearMemory()

    @renderSandbox()
    @overwriteFindWrapColumn()

  # Tear down any state and detach
  destroy: ->
    @subscriptions?.dispose()
    @clearMemory()

    # restore TokenizedLine#findWrapColumn()
    if @originalFindWrapColumn
      TokenizedLine::.findWrapColumn = @originalFindWrapColumn
      @originalFindWrapColumn = null

    ReactDom.unmountComponentAtNode @element
    @element.remove()

  renderSandbox: ->
    wrapStyleSandboxElement = React.createElement WrapStyleSandbox,
      style:
        fontSize: "#{atom.config.get 'editor.fontSize'}px"
        fontFamily: atom.config.get 'editor.fontFamily'
        whiteSpace: atom.config.get 'wrap-style.style.whiteSpace'
        # lineBreak: atom.config.get 'wrap-style.style.lineBreak'
        WebkitLineBreak: atom.config.get 'wrap-style.style.lineBreak'
        wordBreak: atom.config.get 'wrap-style.style.wordBreak'
        # hyphens: atom.config.get 'wrap-style.style.hyphens'
        # WebKitHyphens: atom.config.get 'wrap-style.style.hyphens'
        overflowWrap: atom.config.get 'wrap-style.style.overflowWrap'
      # lang: atom.config.get 'wrap-style.lang'
      strict: atom.config.get 'wrap-style.strictMode'
    @sandbox = ReactDom.render wrapStyleSandboxElement, @element
    @sandbox.initializeDefaultCharWidth()

  # overwrite TokenizedLine#findWrapColumn()
  overwriteFindWrapColumn: ->
    if @originalFindWrapColumn
      console.warn 'overwrited TokenizedLine#findWrapColumn'
      return

    @originalFindWrapColumn = TokenizedLine::.findWrapColumn
    _wrapStyleManager = @
    TokenizedLine::.findWrapColumn = (maxColumn) ->
      # If all characters are full width, the width is twice the length.
      return unless (@text.length * 2) > maxColumn
      return _wrapStyleManager.findWrapColumn(@text, maxColumn)

  clearMemory: ->
    @memoryMap.clear()

  # another findWrapColumn
  findWrapColumn: (text, column) ->
    key = "#{column}:#{text}"
    if @memoryMap.has key
      return @memoryMap.get key

    breakPointList = @sandbox.calculate column, text
    pre = 0
    for i in breakPointList
      @memoryMap.set "#{column}:#{text.substr(pre)}", i - pre
      pre = i
    @memoryMap.set "#{column}:#{text.substr(pre)}", null
    breakPointList[0]
