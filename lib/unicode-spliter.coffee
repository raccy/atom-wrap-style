module.exports =
class UnicoderSpliter
  @unbreakableRegex = new RegExp(require('unicode-8.0.0/blocks/Low Surrogates/regex').toString().slice(1, -1) +
    '|' +
    require('unicode-8.0.0/bidi/NSM/regex').toString().slice(1, -1))

  @splitCharStrict = (text, skip = 0) ->
    return [] unless text
    skip ||= 1
    list = []
    pre = 0
    for i in [skip...text.length]
      unless @unbreakableRegex.test(text[i])
        list.push index: pre, value: text.substring(pre, i)
        pre = i
    list.push index: pre, value: text.substring(pre)
    return list

  @splitChar = (text) ->
    return (index: i, value: text[i] for i in [0...text.length])

  @mapChar = (text, callback, strict = false, skip = 0) ->
    if strict
      return (callback obj for obj in @splitCharStrict text, skip)
    else if skip
      return [callback index: 0, value: text[0...skip]]
        .concat(callback index: i, value: text[i] for i in [skip...text.length])
    else
      return (callback index: i, value: text[i] for i in [0...text.length])
