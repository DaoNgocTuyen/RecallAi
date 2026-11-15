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
  }) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: RecallColors.border),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        hint: Text(label),
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
        items: values
            .map(
              (v) => DropdownMenuItem(
                value: v,
                child: Text(v == 'Tất cả' ? '$label · $v' : v),
              ),
            )
            .toList(),
      ),
    ),
  );
}
