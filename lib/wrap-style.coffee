WrapStyleView = require './wrap-style-view'
{CompositeDisposable} = require 'atom'

module.exports = WrapStyle =
  wrapStyleView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @wrapStyleView = new WrapStyleView(state.wrapStyleViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @wrapStyleView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'wrap-style:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @wrapStyleView.destroy()

  serialize: ->
    wrapStyleViewState: @wrapStyleView.serialize()

  toggle: ->
    console.log 'WrapStyle was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
