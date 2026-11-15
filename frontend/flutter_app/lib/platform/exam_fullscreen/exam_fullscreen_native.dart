import 'package:flutter/services.dart';
import 'exam_fullscreen_driver.dart';

ExamFullscreenDriver createDriver() => _NativeExamFullscreen();

class _NativeExamFullscreen extends ExamFullscreenDriver {
  // Native exams always fill the app window. Android may retain system bars
  // depending on the target SDK; this is not an OS kiosk/device lock.
  @override
  bool get active => true;
  @override
  bool get supported => true;
  @override
  bool get requiresUserActivation => false;
  @override
  Future<bool> enter() async {
    try {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } on PlatformException {
      /* The focused app layout still fills its window. */
    }
    return true;
  }

  @override
  Future<void> exit() async {
    try {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    } on PlatformException {
      /* Platform may already manage its system bars. */
    }
  }

  @override
  void guardUnload(bool enabled) {}
}
