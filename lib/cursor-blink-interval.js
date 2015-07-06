'use babel'
import PackageConfigObserver from 'atom-package-config-observer'

var config = {
  cursorBlinkInterval: {
    description: 'Set to 0 to disable cursor blinking.',
    type: 'integer',
    default: 800,
    minimum: 0
  }
};

var configObserver;

function activate() {
  configObserver = new PackageConfigObserver('cursor-blink-interval');
  configObserver.observeGlobalConfig(updateGlobalCursorBlinkInterval);
  configObserver.observeScopedConfig(updateEditors);
}

function deactivate() {
  configObserver.dispose();
  configObserver = null;
}

function updateGlobalCursorBlinkInterval({cursorBlinkInterval}) {
  var workspaceView = atom.views.getView(atom.workspace);
  workspaceView.classList[cursorBlinkInterval ? 'remove' : 'add']('disable-cursor-blinking');
}

function updateEditors({cursorBlinkInterval}, editors) {
  process.nextTick(function actualUpdateEditors() {
    if(!cursorBlinkInterval) cursorBlinkInterval = -1 + Math.pow(2, 30);
    for(let editor of editors) {
      let editorView = atom.views.getView(editor);
      if(!editorView.component || !editorView.component.presenter) return;
      let editorPresenter = editorView.component.presenter;
      editorPresenter.stopBlinkingCursors(true);
      editorPresenter.cursorBlinkPeriod = cursorBlinkInterval;
      editorPresenter.startBlinkingCursors();
    }
  });
}

export {config, activate, deactivate};
