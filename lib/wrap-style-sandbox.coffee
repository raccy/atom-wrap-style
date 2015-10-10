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
      @findFirstBreak()

  findFirstBreak: ->
    memoryTop = null
    breakPoint = null
    for child in React.findDOMNode(@refs.wrapStyleArea).children
      if memoryTop?
        if memoryTop != child.offsetTop
          breakPoint = Number(child.getAttribute('data-index'))
          break
      else
        memoryTop = child.offsetTop
    breakPoint

  render: ->
    textList = if @props.strict
      UnicodeSpliter.splitCharStrict(@state.text)
    else
      UnicodeSpliter.splitChar(@state.text)

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
