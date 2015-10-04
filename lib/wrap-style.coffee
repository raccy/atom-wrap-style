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
          default: 'normal'
          enum: ['normal', 'pre', 'nowrap', 'pre-wrap', 'pre-line']
        # lineBreak:
        #   type: 'string'
        #   default: 'auto'
        #   enum: ['auto', 'loose', 'normal', 'strict']
        wordBreak:
          type: 'string'
          default: 'normal'
          enum: ['normal', 'keep-all', 'break-all']
        # hyphens:
        #   type: 'string'
        #   default: 'none'
        #   enum: ['none', 'manual', 'auto']
        overflowWrap:
          type: 'string'
          default: 'normal'
          enum: ['normal', 'break-word']
    lang:
      type: 'string'
      default: 'en'

  activate: (state) ->
    @wrapStyleManager = new WrapStyleManager
    # @modalPanel = atom.workspace.addModalPanel(item: @wrapStyleView.getElement(), visible: false)
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.workspace.observeTextEditors (editor) =>
      @wrapStyleManager.overwriteFindWrapColumn(editor)


    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'wrap-style:toggle': => @toggle()

  deactivate: ->
    # @modalPanel.destroy()
    @subscriptions?.dispose()
    @subscriptions = null
    # @wrapStyleView.destroy()
    # for editor in atom.workspace.getTextEditors()
    #   @wrapStyleManager?.restoreFindWrapColumn(editor)

    @wrapStyleManager?.destroy()
    @wrapStyleManager = null

  # serialize: ->
    # wrapStyleViewState: @wrapStyleView.serialize()

  toggle: ->
    console.log 'WrapStyle was toggled!'
    #
    # if @modalPanel.isVisible()
    #   @modalPanel.hide()
    # else
    #   @modalPanel.show()
