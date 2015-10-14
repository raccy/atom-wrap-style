React = require 'react'
UnicodeSpliter = require './unicode-spliter'

module.exports =
class WrapStyleSandbox extends React.Component
  @propTypes =
    style: React.PropTypes.object.isRequired
    strict: React.PropTypes.bool
    lang: React.PropTypes.string
    defaultChar: React.PropTypes.string

  @defaultProps =
    strict: false
    defaultChar: 'x'
    lang: null

  constructor: (props) ->
    super
    @state =
      column: 0
      text: ''
      defaultCharWidth: 0

  initializeDefaultCharWidth: ->
    @setState
      column: 0
      text: @props.defaultChar
    @setState defaultCharWidth: @getFirstCharacterWidth()

  calculate: (column, text) ->
    @setState
      column: column
      text: text
    @findAllBreak()

  # OPTIMIZE: More fast!
  findFirstBreak: ->
    areaElement = @refs.wrapStyleArea
    # if no child, no break
    return null unless areaElement.children.length

    firstTop = areaElement.children[0].offsetTop
    breakPoint = null

    top = 0
    bottom = areaElement.children.length - 1
    # if one line, no break
    return null if areaElement.children[bottom].offsetTop == firstTop

    while bottom - top > 1
      check = (bottom + top) // 2
      if areaElement.children[check].offsetTop == firstTop
        top = check
      else
        bottom = check
    +(areaElement.children[bottom].getAttribute 'data-index')

    # OPTIMIZE: another
    # breakPoint = null
    # for child in areaElement.children
    #   if firstTop != child.offsetTop
    #     breakPoint = +(child.getAttribute 'data-index')
    #     break
    # breakPoint

  # OPTIMIZE: More fast!
  findAllBreak: ->
    breakList = []
    currentTop = null
    for child in @refs.wrapStyleArea.children
      if currentTop != child.offsetTop
        breakList.push +(child.getAttribute 'data-index') if currentTop?
        currentTop = child.offsetTop
    breakList

  getFirstCharacterWidth: ->
    @refs.wrapStyleArea.firstChild?.offsetWidth

  render: ->
    React.DOM.div
      className: 'wrap-style-sandbox'
      # lang: @props.lang
      style: @props.style
      React.DOM.div
        ref: 'wrapStyleArea'
        className: 'wrap-style-area'
        style:
          width: "#{@state.defaultCharWidth * @state.column}px"
        UnicodeSpliter.mapChar @state.text, ({index, value}) ->
          React.DOM.span key: index, 'data-index': index, value
        , @props.strict
