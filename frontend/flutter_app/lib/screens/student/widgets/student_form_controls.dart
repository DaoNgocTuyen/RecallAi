part of '../student_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _StudentStudentFormControlsView on _StudentScreenState {
  String _kind(QuestionKind kind) => switch (kind) {
    QuestionKind.choice => 'Trắc nghiệm',
    QuestionKind.trueFalse => 'Đúng / Sai',
    QuestionKind.shortAnswer => 'Tự luận ngắn',
  };

  Widget _dropdown(
    String value,
    List<String> values,
    ValueChanged<String> onChanged, {
    required String label,
  }) => RecallSelect(
    value: value,
    items: values,
    onChanged: onChanged,
    hint: label,
  );
}
