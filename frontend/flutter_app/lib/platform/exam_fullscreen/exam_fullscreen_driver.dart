import 'package:flutter/foundation.dart';

abstract class ExamFullscreenDriver extends ChangeNotifier {
  bool get active;
  bool get supported;
  bool get requiresUserActivation;
  Future<bool> enter();
  Future<void> exit();
  void guardUnload(bool enabled);
}
