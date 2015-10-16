module.exports =
class UnicoderSpliter
  @highSurrogate = [].concat(
    require('unicode-8.0.0/blocks/High Surrogates/code-points'),
    require('unicode-8.0.0/blocks/High Private Use Surrogates/code-points'))
  @lowSurrogate = [].concat(
    require('unicode-8.0.0/blocks/Low Surrogates/code-points'),
    require('unicode-8.0.0/blocks/Private Use Area/code-points'))
  @nsm = require('unicode-8.0.0/bidi/NSM/code-points')
  @unbreakableChars = [].concat(@lowSurrogate, @nsm)

  @splitCharStrict = (text) ->
    return [] unless text
    list = []
    pre = 0
    for i in [1...text.length]
      unless text.charCodeAt(i) in @unbreakableChars
        list.push index: pre, value: text.substring(pre, i)
        pre = i
    list.push index: pre, value: text.substring(pre)
    return list

  @splitChar = (text) ->
    return (index: i, value: text.charAt(i) for i in [0...text.length])

  @mapChar = (text, callback, strict = false, skip = 0) ->
    if strict
      return (callback obj for obj in @splitCharStrict text)
    else if skip
      return [callback index: 0, value: text[0...skip]]
        .concat(callback index: i, value: text[i] for i in [skip...text.length])
    else
      return (callback index: i, value: text[i] for i in [0...text.length])
