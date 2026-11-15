import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recallai_frontend/design/recall_theme.dart';
import 'package:recallai_frontend/models/demo_store.dart';
import 'package:recallai_frontend/models/exam_draft.dart';
import 'package:recallai_frontend/widgets/recall_widgets.dart';

part 'pages/create_exam_page.dart';
part 'pages/exam_configuration_page.dart';
part 'pages/exam_created_page.dart';
part 'pages/exam_settings_page.dart';
part 'widgets/file_upload_panel.dart';
part 'widgets/exam_form_controls.dart';

class ExamCreationScreen extends StatefulWidget {
  const ExamCreationScreen({super.key, required this.path});
  final String path;
  @override
  State<ExamCreationScreen> createState() => _ExamCreationScreenState();
}

class _ExamCreationScreenState extends State<ExamCreationScreen> {
  final formKey = GlobalKey<FormState>();
  final controllers = <String, TextEditingController>{};
  ExamDraft? editing;
  bool dragging = false, choosing = false;
  String? fileError;
  String get section => widget.path.split('/').last;
  @override
  void dispose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = DemoScope.of(context);
    final title = switch (section) {
      'exam-config' => 'Cấu hình chung',
      'exam-success' => 'Tạo đề thành công',
      'exam-settings' => 'Cài đặt làm bài online',
      _ => 'Tạo đề mới',
    };
    return AppShell(
      teacher: true,
      active: 3,
      title: title,
      child: VStack([
        ActionGroup([
          TextButton.icon(
            onPressed: () => go(
              context,
              section == 'builder'
                  ? '/teacher/quizzes'
                  : section == 'exam-settings'
                  ? '/teacher/exam-success'
                  : '/teacher/builder',
            ),
            icon: const Icon(Icons.arrow_back, size: 18),
            label: Text(
              section == 'builder' ? 'Quản lý bài kiểm tra' : 'Quay lại',
            ),
          ),
          const Pill('Bản mô phỏng · Lưu trong phiên'),
        ]),
        switch (section) {
          'exam-config' => _configuration(store),
          'exam-success' => _success(store),
          'exam-settings' => _settings(store),
          _ => _creationHub(store),
        },
      ], gap: 20),
    );
  }

  void _refresh(VoidCallback update) => setState(update);

  ExamDraft _newDraft(DemoStore store, ExamMethod method) =>
      ExamDraft(
          id: 'EXAM-${(store.nextExamId++).toString().padLeft(3, '0')}',
          method: method,
        )
        ..questionIds.addAll(store.selectedQuestions)
        ..minutes = store.assignmentMinutes
        ..attempts = store.maxAttempts;

  ExamDraft _editing(DemoStore store) =>
      editing ??= store.pendingExam ?? _newDraft(store, ExamMethod.manual);

  TextEditingController _controller(String key, String value) =>
      controllers.putIfAbsent(key, () => TextEditingController(text: value));
}
