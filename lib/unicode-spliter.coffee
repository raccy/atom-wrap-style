regenerate = require 'regenerate'

module.exports =
class UnicoderSpliter
  @unbreakableRegex = regenerate()
    .add(require('unicode-8.0.0/blocks/Low Surrogates/code-points'))
    .add(require('unicode-8.0.0/bidi/NSM/code-points'))
    .toRegExp()

  @splitChar = (text, strict = false, skip = 0) ->
    return @mapChar text, ((index, value) -> {index: index, value: value}), strict, skip

  @mapChar = (text, callback, strict = false, skip = 0) ->
    return [] unless text
    skip ||= 1
    if strict
      list = []
      pre = 0
      for i in [skip...text.length]
        unless @unbreakableRegex.test(text[i])
          list.push(callback pre, text.substring(pre, i))
          pre = i
      list.push(callback pre, text.substring(pre))
      return list
    else
      return [callback 0, text[0...skip]]
        .concat(callback i, text[i] for i in [skip...text.length])
