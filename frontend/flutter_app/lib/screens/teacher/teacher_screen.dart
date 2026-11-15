import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recallai_frontend/design/recall_theme.dart';
import 'package:recallai_frontend/models/demo_store.dart';
import 'package:recallai_frontend/widgets/recall_widgets.dart';
import 'widgets/recall_table.dart';

part 'dashboard/dashboard_page.dart';
part 'classrooms/classrooms_page.dart';
part 'classrooms/classroom_details_page.dart';
part 'questions/ai_question_generator_page.dart';
part 'questions/question_bank_page.dart';
part 'questions/question_editor_page.dart';
part 'exams/editor/exam_editor_page.dart';
part 'exams/assignments/assign_exam_page.dart';
part 'exams/management/exams_page.dart';
part 'grading/grading_page.dart';
part 'analytics/teaching_analytics_page.dart';
part 'recommendations/review_recommendations_page.dart';
part 'widgets/question_kind_label.dart';

const _teacherTitles = {
  'dashboard': 'Tổng quan',
  'classes': 'Quản lý lớp học',
  'classroom': 'Chi tiết lớp học',
  'generate': 'Tạo câu hỏi bằng AI',
  'questions': 'Ngân hàng câu hỏi',
  'edit': 'Biên tập câu hỏi',
  'editor': 'Biên tập đề thi',
  'builder': 'Tạo bài kiểm tra',
  'assign': 'Giao bài kiểm tra',
  'quizzes': 'Quản lý bài kiểm tra',
  'grading': 'Chấm điểm',
  'analytics': 'Thống kê kết quả học tập',
  'recommendations': 'Đề xuất ôn tập',
};

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key, required this.path});
  final String path;
  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  String query = '',
      filter = 'Tất cả',
      tab = 'Tổng quan',
      answerPolicy = 'Sau khi trả kết quả';
  int step = 0;
  bool generated = false, busy = false;
  String get section => widget.path.split('/').last;
  @override
  Widget build(BuildContext context) {
    final s = DemoScope.of(context);
    final active = switch (section) {
      'dashboard' => 0,
      'classes' || 'classroom' => 1,
      'generate' || 'questions' || 'edit' => 2,
      'editor' || 'builder' || 'assign' || 'quizzes' => 3,
      'grading' => 4,
      'analytics' => 5,
      _ => 6,
    };
    final body = switch (section) {
      'dashboard' => _dashboard(s),
      'classes' => _classes(s),
      'classroom' => _classroom(s),
      'generate' => _generate(s),
      'questions' => _questions(s),
      'edit' => _edit(s),
      'editor' || 'builder' => _builder(s),
      'assign' => _assign(s),
      'quizzes' => _quizzes(s),
      'grading' => _grading(s),
      'analytics' => _analytics(s),
      _ => _recommendations(s),
    };
    return AppShell(
      title: _teacherTitles[section] ?? 'Không gian giáo viên',
      teacher: true,
      active: active,
      child: body,
    );
  }

  void _refresh(VoidCallback update) => setState(update);
}
