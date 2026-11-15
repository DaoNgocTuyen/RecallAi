part of '../teacher_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _TeacherQuestionKindLabelView on _TeacherScreenState {
  String _kind(QuestionKind kind) => switch (kind) {
    QuestionKind.choice => 'Trắc nghiệm',
    QuestionKind.trueFalse => 'Đúng / Sai',
    QuestionKind.shortAnswer => 'Tự luận ngắn',
  };
}
