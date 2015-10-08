TokenizedLine = require 'src/tokenized-line'
React = require 'react'
WrapStyleSandbox = require './wrap-style-sandbox'

module.exports =
class WrapStyleManager
  constructor: ->
    @defaultCharWidth = null
    @originalFindWrapColumn = null

    # Create root element
    @element = document.createElement 'div'
    @element.classList.add 'wrap-style'
    atom.views.getView atom.workspace
      .appendChild @element

    @memoryMap = new Map
    @overwriteFindWrapColumn()

  # Tear down any state and detach
  destroy: ->
    # restore TokenizedLine#findWrapColumn()
    if @originalFindWrapColumn
      TokenizedLine::.findWrapColumn = @originalFindWrapColumn
      @originalFindWrapColumn = null

    @element.remove()

  getElement: ->
    @element

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

  getWidth: (column) ->
    @defaultCharWidth ||= atom.workspace.getActiveTextEditor().displayBuffer.getDefaultCharWidth()
    column * @defaultCharWidth

  clearMemory: ->
    @memoryMap.clear()

  # another findWrapColumn
  findWrapColumn: (text, column) ->
    key = "#{column}:#{text}"
    if @memoryMap.has key
      console.log 'use memoryMap'
      return @memoryMap.get key

    width = @getWidth(column)
    # width is 0 or null
    unless width
      console.warn 'not set width'
      return null

    wrapStyleSandboxElement = React.createElement WrapStyleSandbox,
      style:
        fontSize: "#{atom.config.get 'editor.fontSize'}px"
        fontFamily: atom.config.get 'editor.fontFamily'
        whiteSpace: atom.config.get 'wrap-style.style.whiteSpace'
        # lineBreak: atom.config.get 'wrap-style.style.lineBreak'
        WebkitLineBreak: atom.config.get 'wrap-style.style.lineBreak'
        wordBreak: atom.config.get 'wrap-style.style.wordBreak'
        # hyphens: atom.config.get 'wrap-style.style.hyphens'
        overflowWrap: atom.config.get 'wrap-style.style.overflowWrap'
      size: width
      lang: atom.config.get 'wrap-style.lang'
      text: text
    React.render wrapStyleSandboxElement, @element
    memoryTop = null
    breakPoint = null
    for child in @element.querySelector('.wrap-style-sandbox').children
      if memoryTop?
        if memoryTop != child.offsetTop
          breakPoint = Number(child.getAttribute('data-index'))
          break
      else
        memoryTop = child.offsetTop
    console.log "#{column}-#{width}/#{breakPoint}/#{text}"
    @memoryMap.set key, breakPoint
    breakPoint
