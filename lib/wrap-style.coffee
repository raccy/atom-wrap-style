WrapStyleManager = require './wrap-style-manager'

module.exports = WrapStyle =
  wrapStyleView: null
  modalPanel: null
  subscriptions: null

  config:
    style:
      type: 'object'
      properties:
        whiteSpace:
          type: 'string'
          default: 'pre-wrap'
          enum: ['normal', 'pre', 'nowrap', 'pre-wrap', 'pre-line']
        lineBreak:
          type: 'string'
          default: 'strict'
          enum: ['auto', 'loose', 'normal', 'strict']
        wordBreak:
          type: 'string'
          default: 'normal'
          # HACK: not support `keep-all`
          # enum: ['normal', 'keep-all', 'break-all']
          enum: ['normal', 'break-all']
          description: 'Not support **keep-all**'
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
    # lang:
    #   type: 'string'
    #   default: 'en'
    #   description: 'Effect hyphenation. But not support hyphenation, so ignore this paramator.'

  activate: (state) ->
    @wrapStyleManager = new WrapStyleManager

  deactivate: ->
    @wrapStyleManager?.destroy()
    @wrapStyleManager = null
