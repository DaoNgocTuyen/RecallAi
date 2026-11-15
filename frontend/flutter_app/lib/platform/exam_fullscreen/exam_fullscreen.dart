import 'exam_fullscreen_driver.dart';
import 'exam_fullscreen_native.dart'
    if (dart.library.js_interop) 'exam_fullscreen_web.dart'
    as platform;

ExamFullscreenDriver createExamFullscreenDriver() => platform.createDriver();
