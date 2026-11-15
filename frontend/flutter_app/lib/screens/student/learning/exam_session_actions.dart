part of '../student_screen.dart';

extension _StudentExamSessionActions on _StudentScreenState {
  Future<void> _beginExam(
    DemoStore store, {
    bool weakOnly = false,
    bool assigned = false,
  }) async {
    if (_startingExam) return;
    _startingExam = true;
    // Request while the start button still supplies browser user activation.
    final request = createExamFullscreenDriver();
    try {
      await request.enter();
    } finally {
      request.dispose(); // The quiz route takes over the fullscreen session.
      _startingExam = false;
    }
    if (!mounted) return;
    store.beginQuiz(weakOnly: weakOnly, assigned: assigned);
    go(context, '/student/quiz');
  }

  Future<void> _finishExamSubmission(DemoStore store) async {
    if (_submitting || store.submitted) return;
    if (_examFullscreen?.active == false) {
      Navigator.of(context).pop();
      return; // Return to the fullscreen gate without submitting.
    }
    _submitting = true;
    final destination = store.assignedMode
        ? '/student/assigned-results'
        : '/student/results';
    store.submitQuiz();
    _examFullscreen?.guardUnload(false);
    Navigator.of(context).pop(); // Close the confirmation, not the quiz route.
    await _examFullscreen?.exit();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(destination);
  }
}
