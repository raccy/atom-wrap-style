module.exports =
class UnicoderSpliter
  @highSurrogate = [].concat(
    require('unicode-8.0.0/blocks/High Surrogates/code-points'),
    require('unicode-8.0.0/blocks/High Private Use Surrogates/code-points'))
  @lowSurrogate = [].concat(
    require('unicode-8.0.0/blocks/Low Surrogates/code-points'),
    require('unicode-8.0.0/blocks/Private Use Area/code-points'))
  @nsm = require('unicode-8.0.0/bidi/NSM/code-points')

  # TODO: consider Combining Characters
  # FIXME: If the last is only a High Surrogate, broken and no warning message.
  @splitChar = (text) ->
    inSurrogate = false
    list = []
    for i in [0...text.length]
      if inSurrogate
        inSurrogate = false
        if text.charCodeAt(i) in @lowSurrogate
          list.push index: i - 1, value: text[(i - 1)..i]
        else
          console.warn "broken surrogate: #{i}, #{text.charCodeAt(i - 1)}, #{text.charCodeAt(i)}"
          list.push index: i - 1, value: text[i - 1]
          list.push index: i, value: text[i]
      else if text.charCodeAt(i) in @highSurrogate
        inSurrogate = true
        # not add list
      else
        list.push index: i, value: text[i]
    return list
