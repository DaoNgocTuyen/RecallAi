import 'dart:js_interop';
import 'package:web/web.dart' as web;
import 'exam_fullscreen_driver.dart';

ExamFullscreenDriver createDriver() => _WebExamFullscreen();

class _WebExamFullscreen extends ExamFullscreenDriver {
  _WebExamFullscreen() {
    _changed = ((web.Event event) {
      notifyListeners();
    }).toJS;
    _unload = ((web.Event event) {
      event.preventDefault();
      (event as web.BeforeUnloadEvent).returnValue = '';
    }).toJS;
    web.document.addEventListener('fullscreenchange', _changed);
  }
  late final JSFunction _changed, _unload;
  bool _guarding = false;
  @override
  bool get active => web.document.fullscreenElement != null;
  @override
  bool get supported => web.document.fullscreenEnabled;
  @override
  bool get requiresUserActivation => true;
  @override
  Future<bool> enter() async {
    if (active) return true;
    if (!supported) return false;
    try {
      await web.document.documentElement!.requestFullscreen().toDart;
      return active;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> exit() async {
    if (!active) return;
    try {
      await web.document.exitFullscreen().toDart;
    } catch (_) {
      /* Already exited. */
    }
  }

  @override
  void guardUnload(bool enabled) {
    if (enabled == _guarding) return;
    _guarding = enabled;
    if (enabled) {
      web.window.addEventListener('beforeunload', _unload);
    } else {
      web.window.removeEventListener('beforeunload', _unload);
    }
  }

  @override
  void dispose() {
    guardUnload(false);
    web.document.removeEventListener('fullscreenchange', _changed);
    super.dispose();
  }
}
