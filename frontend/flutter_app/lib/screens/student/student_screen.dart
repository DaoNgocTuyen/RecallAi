import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:recallai_frontend/design/recall_theme.dart';
import 'package:recallai_frontend/models/demo_store.dart';
import 'package:recallai_frontend/widgets/recall_widgets.dart';
import 'package:recallai_frontend/platform/exam_fullscreen/exam_fullscreen.dart';
import 'package:recallai_frontend/platform/exam_fullscreen/exam_fullscreen_driver.dart';
import 'learning/widgets/focused_exam_scaffold.dart';

part 'dashboard/dashboard_page.dart';
part 'documents/document_library_page.dart';
part 'documents/pdf_viewer_page.dart';
part 'learning/learning_studio_page.dart';
part 'learning/question_generator_page.dart';
part 'learning/active_recall_page.dart';
part 'learning/exam_session_actions.dart';
part 'learning/quiz_results_page.dart';
part 'learning/mistake_analysis_page.dart';
part 'flashcards/flashcard_editor.dart';
part 'flashcards/flashcard_decks_page.dart';
part 'flashcards/flashcard_review_page.dart';
part 'review/review_calendar_page.dart';
part 'analytics/learning_analytics_page.dart';
part 'planner/study_planner_page.dart';
part 'classrooms/classrooms_page.dart';
part 'classrooms/assigned_quiz_page.dart';
part 'classrooms/assigned_results_page.dart';
part 'widgets/student_form_controls.dart';

const _studentTitles = {
  'dashboard': 'Tổng quan học tập',
  'documents': 'Thư viện tài liệu',
  'upload': 'Thêm tài liệu học tập',
  'studio': 'AI Learning Studio',
  'processing': 'AI phân tích tài liệu',
  'pdf': 'Không gian học tập',
  'generator': 'Tạo bài luyện tập',
  'preview': 'Xem trước câu hỏi',
  'quiz': 'Luyện tập kiến thức',
  'results': 'Kết quả luyện tập',
  'explanation': 'Giải thích đáp án',
  'decks': 'Bộ thẻ ghi nhớ',
  'flashcards': 'Học bằng Flashcard',
  'review': 'Lịch ôn tập',
  'analytics': 'Thống kê học tập',
  'weak-topics': 'Kiến thức cần củng cố',
  'planner': 'Kế hoạch ôn thi',
  'daily': 'Kế hoạch học tập trong ngày',
  'classes': 'Lớp học của tôi',
  'join': 'Tham gia lớp học',
  'classroom': 'Chi tiết lớp học',
  'assignments': 'Bài kiểm tra được giao',
  'assigned-quiz': 'Bài kiểm tra',
  'assigned-results': 'Kết quả kiểm tra',
};

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key, required this.path});
  final String path;
  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  ExamFullscreenDriver? _examFullscreen;
  bool _submitting = false, _startingExam = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (section == 'quiz') {
      _examFullscreen ??= createExamFullscreenDriver();
      final store = DemoScope.of(context);
      if (!store.submitted) store.examInProgress = true;
    }
  }

  String query = '',
      subject = 'Tất cả',
      status = 'Tất cả',
      documentOrder = 'Mới nhất',
      classTab = 'Tổng quan';
  bool listView = false,
      busy = false,
      generated = false,
      textMode = false,
      flipped = false,
      monthly = false,
      assistantVisible = true,
      compactAssistant = false;
  int? page;
  int zoom = 100, period = 7;
  final _answerControllers = <int, TextEditingController>{};
  @override
  void dispose() {
    final fullscreen = _examFullscreen;
    if (fullscreen != null) {
      fullscreen.guardUnload(false);
      unawaited(fullscreen.exit());
      fullscreen.dispose();
    }
    for (final controller in _answerControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String pdfTab = 'Câu hỏi', deckFilter = 'Tất cả';
  String get section => widget.path.split('/').last;
  @override
  Widget build(BuildContext context) {
    final s = DemoScope.of(context);
    final active = switch (section) {
      'dashboard' => 0,
      'documents' || 'upload' || 'pdf' => 1,
      'decks' || 'flashcards' => 3,
      'review' => 4,
      'analytics' || 'weak-topics' => 5,
      'planner' || 'daily' => 6,
      'classes' ||
      'join' ||
      'classroom' ||
      'assignments' ||
      'assigned-quiz' ||
      'assigned-results' => 7,
      _ => 2,
    };
    final child = switch (section) {
      'dashboard' => _dashboard(s),
      'documents' => _documents(s),
      'studio' || 'upload' || 'processing' => _studio(s),
      'pdf' => _pdf(s),
      'generator' || 'preview' => _generator(s),
      'quiz' => _quiz(s),
      'results' => _results(s),
      'explanation' => _explanation(s),
      'decks' => _decks(s),
      'flashcards' => _flashcards(s),
      'review' => _review(s),
      'analytics' || 'weak-topics' => _analytics(s),
      'planner' || 'daily' => _planner(s),
      'classes' || 'join' || 'classroom' || 'assignments' => _classes(s),
      'assigned-quiz' => _assignedInstructions(s),
      'assigned-results' => _assignedResults(s),
      _ => _dashboard(s),
    };
    if (section == 'quiz') {
      return FocusedExamScaffold(
        driver: _examFullscreen!,
        title: s.assignedMode ? 'Bài kiểm tra' : _studentTitles[section]!,
        submitted: s.submitted,
        child: child,
      );
    }
    return AppShell(
      title: _studentTitles[section] ?? 'RecallAI',
      active: active,
      child: child,
    );
  }

  void _refresh(VoidCallback update) => setState(update);
}
