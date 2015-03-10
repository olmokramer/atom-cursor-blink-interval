'use strict'
_ = require 'underscore'

class CursorBlinkInterval
  config:
    interval:
      description: 'Interval of the cursor blink - the period between primaryColor and secondaryColor - in milliseconds. Set to 0 to disable blinking (Note: doesn\'t apply to mini editors yet)'
      type: 'integer'
      default: 400
      minimum: 0

  activate: ->
    @configSub = atom.config.observe 'cursor-blink-interval.interval', @applyInterval
    @editorSub = null

  deactivate: ->
    @configSub.dispose()
    @editorSub?.dispose?()

  applyInterval: (interval) =>
    @editorSub?.dispose?()
    @editorSub = atom.workspace.observeTextEditors (editor) ->
      editorPresenter = atom.views.getView(editor).component.presenter
      editorPresenter.cursorBlinkPeriod = interval * 2
      editorPresenter.stopBlinkingCursors(true)
      if interval > 0
        editorPresenter.startBlinkingCursorsAfterDelay = do ->
          _.debounce(editorPresenter.startBlinkingCursors, editorPresenter.getCursorBlinkResumeDelay())
      else
        editorPresenter.startBlinkingCursorsAfterDelay = ->

module.exports = new CursorBlinkInterval()
