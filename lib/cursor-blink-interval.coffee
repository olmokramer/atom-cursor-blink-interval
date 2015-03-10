'use strict'
class CursorBlinkInterval
  config:
    cursorBlinkInterval:
      description: 'Cursor blink interval in milliseconds. Set to 0 to disable blinking (Note: doesn\'t apply to mini editors)'
      type: 'integer'
      default: 800
      minimum: 0

  activate: ->
    @configSub = atom.config.observe 'cursor-blink-interval.cursorBlinkInterval', @applyCursorBlinkInterval
    @editorSub = null

  deactivate: ->
    @configSub.dispose()
    @editorSub?.dispose?()

  applyCursorBlinkInterval: (cursorBlinkInterval) =>
    @editorSub?.dispose?()
    @editorSub = atom.workspace.observeTextEditors (editor) ->
      editorPresenter = atom.views.getView(editor).component.presenter
      editorPresenter.stopBlinkingCursors(true)
      if cursorBlinkInterval > 0
        editorPresenter.cursorBlinkPeriod = cursorBlinkInterval
        atom.views.getView(atom.workspace).classList.remove 'disable-cursor-blinking'
      else
        editorPresenter.cursorBlinkPeriod = -1 + Math.pow 2, 31
        atom.views.getView(atom.workspace).classList.add 'disable-cursor-blinking'
      editorPresenter.startBlinkingCursors()

module.exports = new CursorBlinkInterval()
