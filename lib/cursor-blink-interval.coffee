'use strict'
PackageConfigObserver = require 'atom-package-config-observer'

class CursorBlinkInterval
  config:
    cursorBlinkInterval:
      description: 'Cursor blink interval in milliseconds. Set to 0 to disable blinking (Note: doesn\'t apply to mini editors)'
      type: 'integer'
      default: 800
      minimum: 0

  activate: ->
    @configObserver = new PackageConfigObserver 'cursor-blink-interval'
    @configObserver.observeGlobalConfig @updateGlobalCursorBlinkInterval
    @configObserver.observeScopedConfig @updateEditors

  deactivate: ->
    @configObserver.dispose()

  updateGlobalCursorBlinkInterval: (config) ->
    if config.cursorBlinkInterval is 0
      atom.views.getView(atom.workspace).classList.add 'disable-cursor-blinking'
    else
      atom.views.getView(atom.workspace).classList.remove 'disable-cursor-blinking'

  updateEditors: (config, editors) =>
    cursorBlinkInterval = config.cursorBlinkInterval
    if cursorBlinkInterval is 0
      cursorBlinkInterval = -1 + Math.pow 2, 31
    for editor in editors
      editorPresenter = atom.views.getView(editor).component.presenter
      editorPresenter.stopBlinkingCursors true
      editorPresenter.cursorBlinkPeriod = cursorBlinkInterval
      editorPresenter.startBlinkingCursors()

module.exports = new CursorBlinkInterval()
