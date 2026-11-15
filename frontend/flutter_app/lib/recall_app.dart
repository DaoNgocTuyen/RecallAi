import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'design/recall_theme.dart';
import 'models/demo_store.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/student/student_screen.dart';
import 'screens/teacher/teacher_screen.dart';
import 'screens/teacher/exams/creation/exam_creation_screen.dart';
import 'screens/settings/settings_screen.dart';

class RecallApp extends StatefulWidget {
  const RecallApp({super.key, this.initialRoute, this.store});
  final String? initialRoute;
  final DemoStore? store;
  @override
  State<RecallApp> createState() => _RecallAppState();
}

class _RecallAppState extends State<RecallApp> {
  late final DemoStore store = widget.store ?? DemoStore();
  @override
  void dispose() {
    if (widget.store == null) store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DemoScope(
    store: store,
    child: MaterialApp(
      title: 'RecallAI — Học chủ động, nhớ lâu hơn',
      debugShowCheckedModeBanner: false,
      theme: recallTheme(),
      locale: const Locale('vi'),
      supportedLocales: const [Locale('vi'), Locale('en')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      initialRoute:
          widget.initialRoute ??
          (Uri.base.fragment.isNotEmpty ? Uri.base.fragment : '/login'),
      onGenerateRoute: (settings) {
        final path = settings.name ?? '/login';
        final Widget screen;
        if (path == '/settings') {
          screen = const SettingsScreen();
        } else if (path.startsWith('/student/')) {
          screen = StudentScreen(path: path);
        } else if (const [
          '/teacher/builder',
          '/teacher/exam-config',
          '/teacher/exam-success',
          '/teacher/exam-settings',
        ].contains(path)) {
          screen = ExamCreationScreen(path: path);
        } else if (path.startsWith('/teacher/')) {
          screen = TeacherScreen(path: path);
        } else {
          screen = AuthScreen(path: path);
        }
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => screen,
        );
      },
    ),
  );
}
