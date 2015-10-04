React = require 'react'
R = require 'ramda'

module.exports =
class WrapStyleSandbox extends React.Component

  @highSurrogateRange = [0xD800..0xDBFF]
  @lowSurrogateRange = [0xDC00..0xDFFF]

  # TODO: consider Combining Characters
  # FIXME: If the last is only a High Surrogate, broken and no warning message.
  @splitChar = (text) ->
    inSurrogate = false
    list = []
    for i in [0...text.length]
      if inSurrogate
        inSurrogate = false
        if text.charCodeAt(i) in @lowSurrogateRange
          list.push index: i - 1, value: text[(i - 1)..i]
        else
          console.warn "broken surrogate: #{i}, #{text.charCodeAt(i - 1)}, #{text.charCodeAt(i)}"
          list.push index: i - 1, value: text[i - 1]
          list.push index: i, value: text[i]
      else if text.charCodeAt(i) in @highSurrogateRange
        inSurrogate = true
        # not add list
      else
        list.push index: i, value: text[i]
    return list

  render: ->
    style = R.merge(@props.style, {width: "#{@props.size}px"})
    React.DOM.div
      className: 'wrap-style-sandbox',
      lang: @props.lang
      style: style,
      for {index, value} in WrapStyleSandbox.splitChar(@props.text)
        React.DOM.span key: index, 'data-index': index, value
