{CompositeDisposable} = require 'atom'
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
          # HACK: not support keep-all [WebKit bug 43917](https://bugs.webkit.org/show_bug.cgi?id=43917)
          # enum: ['normal', 'keep-all', 'break-all']
          enum: ['normal', 'break-all']
        # hyphens:
        #   type: 'string'
        #   default: 'none'
        #   enum: ['none', 'manual', 'auto']
        overflowWrap:
          type: 'string'
          default: 'break-word'
          enum: ['normal', 'break-word']
    lang:
      type: 'string'
      default: 'en'

  activate: (state) ->
    @wrapStyleManager = new WrapStyleManager
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.workspace.observeTextEditors (editor) =>
      @wrapStyleManager.overwriteFindWrapColumn(editor)
    @subscriptions.add atom.workspace.observeActivePaneItem (item) =>
      @wrapStyleManager.clearMemory()

  deactivate: ->
    @subscriptions?.dispose()
    @subscriptions = null
    @wrapStyleManager?.destroy()
    @wrapStyleManager = null
