WrapStyleManager = require './wrap-style-manager'

module.exports = WrapStyle =
  wrapStyleManager: null

  config:
    enabled:
      type: 'boolean'
      default: true
    style:
      type: 'object'
      properties:
        whiteSpace:
          type: 'string'
          default: 'pre-wrap'
          enum: ['normal', 'pre', 'nowrap', 'pre-wrap', 'pre-line']
          description: 'You should use **pre-warp**. Others are experimental. (default: pre-wrap)'
        lineBreak:
          type: 'string'
          default: 'strict'
          enum: ['auto', 'loose', 'normal', 'strict']
          description: 'Line breaking rules in East Asian languages. (default: strict)'
        wordBreak:
          type: 'string'
          default: 'normal'
          # HACK: not support `keep-all`
          # enum: ['normal', 'keep-all', 'break-all']
          enum: ['normal', 'break-all']
          description: 'If you want hard wrap, select **break-all**. Not support **keep-all**. (default: normal)'
        # hyphens:
        #   type: 'string'
        #   default: 'none'
        #   # HACK: support only `none`
        #   # enum: ['none', 'manual', 'auto']
        #   enum: ['none']
        #   description: 'Support only **none**'
        overflowWrap:
          type: 'string'
          default: 'break-word'
          enum: ['normal', 'break-word']
          description: '**break-word** breaks long long words that overflow in a line. (default: break-word)'
    # lang:
    #   type: 'string'
    #   default: 'en'
    #   description: 'Effect hyphenation. But not support hyphenation, so ignore this paramator.'
    strictMode:
      type: 'boolean'
      default: false
      description: 'Consider NFD characters and Surrogate pairs, but slower.'

  activate: (state) ->
    @wrapStyleManager = new WrapStyleManager

  deactivate: ->
    @wrapStyleManager?.destroy()
    @wrapStyleManager = null
