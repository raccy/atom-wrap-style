React = require 'react'
UnicodeSpliter = require './unicode-spliter'
module.exports =
class WrapStyleSandbox extends React.Component
  constructor: (props) ->
    super
    @state =
      width: 0
      text: ''
    @props.manager.setCalculate (width, text) =>
      @setState
        width: width
        text: text
      @findAllBreak()

  findFirstBreak: ->
    areaElement = React.findDOMNode @refs.wrapStyleArea
    # if no child, no break
    return null unless areaElement.children.length

    firstTop = areaElement.children[0].offsetTop
    breakPoint = null

    top = 0
    bottom = areaElement.children.length - 1
    # if one line, no break
    return null if areaElement.children[bottom].offsetTop == firstTop

    # OPTIMIZE: More fast!
    while bottom - top > 1
      check = (bottom + top) // 2
      if areaElement.children[check].offsetTop == firstTop
        top = check
      else
        bottom = check
    Number areaElement.children[bottom].getAttribute 'data-index'

    # OPTIMIZE: some case, fast?
    # breakPoint = null
    # for child in areaElement.children
    #   if firstTop != child.offsetTop
    #     breakPoint = Number(child.getAttribute('data-index'))
    #     break
    # breakPoint

  findAllBreak: ->
    areaElement = React.findDOMNode @refs.wrapStyleArea
    breakList = []
    # if no child, no break
    return breakList unless areaElement.children.length

    # OPTIMIZE: More fast!
    currentTop = null
    for child in areaElement.children
      if currentTop != child.offsetTop
        breakList.push(Number(child.getAttribute('data-index'))) if currentTop?
        currentTop = child.offsetTop
    breakList

  getFirstCharacterWidth: ->
    React.findDOMNode(@refs.wrapStyleArea).firstChild?.offsetWidth

  render: ->
    textList = if @props.strict
      UnicodeSpliter.splitCharStrict @state.text
    else
      UnicodeSpliter.splitChar @state.text

    React.DOM.div
      className: 'wrap-style-sandbox'
      lang: @props.lang
      style: @props.style
      React.DOM.div
        ref: 'wrapStyleArea'
        className: 'wrap-style-area'
        style:
          width: "#{@state.width}px"
        for {index, value} in textList
          React.DOM.span key: index, 'data-index': index, value
