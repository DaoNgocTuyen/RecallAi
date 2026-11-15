import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recallai_frontend/design/recall_theme.dart';
import 'package:recallai_frontend/models/demo_store.dart';
import 'package:recallai_frontend/platform/exam_fullscreen/exam_fullscreen_driver.dart';
import 'package:recallai_frontend/recall_app.dart';
import 'package:recallai_frontend/screens/student/learning/widgets/focused_exam_scaffold.dart';
import 'package:recallai_frontend/widgets/recall_widgets.dart';

class FakeFullscreen extends ExamFullscreenDriver {
  FakeFullscreen({this.isActive = false, this.allow = true});
  bool isActive, allow, guarding = false;
  int enters = 0;
  @override
  bool get active => isActive;
  @override
  bool get supported => true;
  @override
  bool get requiresUserActivation => true;
  @override
  Future<bool> enter() async {
    enters++;
    if (allow) {
      isActive = true;
      notifyListeners();
    }
    return isActive;
  }

  @override
  Future<void> exit() async {
    isActive = false;
    notifyListeners();
  }

  @override
  void guardUnload(bool enabled) {
    guarding = enabled;
  }

  void escape() {
    isActive = false;
    notifyListeners();
  }
}

void main() {
  setUpAll(() async {
    await DesignAssets.load();
    await (FontLoader(
      'Inter',
    )..addFont(rootBundle.load('assets/fonts/Inter.ttf'))).load();
  });
  testWidgets(
    'fullscreen gate hides questions after exit and preserves child answers',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final driver = FakeFullscreen();
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          theme: recallTheme(),
          home: FocusedExamScaffold(
            driver: driver,
            title: 'Quiz',
            submitted: false,
            child: TextField(controller: controller),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsNothing);
      expect(driver.guarding, isTrue);
      await tester.tap(find.text('Vào toàn màn hình để làm bài'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'SQL JOIN answer');
      driver.escape();
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsNothing);
      expect(controller.text, 'SQL JOIN answer');
      await tester.tap(find.text('Vào toàn màn hình để làm bài'));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);
      expect(controller.text, 'SQL JOIN answer');
      expect(driver.enters, 2);
      await tester.pumpWidget(const SizedBox.shrink());
      expect(driver.guarding, isFalse);
      driver.dispose();
      controller.dispose();
    },
  );
  testWidgets('fullscreen denied keeps questions inaccessible', (tester) async {
    final driver = FakeFullscreen(allow: false);
    await tester.pumpWidget(
      MaterialApp(
        theme: recallTheme(),
        home: FocusedExamScaffold(
          driver: driver,
          title: 'Quiz',
          submitted: false,
          child: const Text('Question content'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Vào toàn màn hình để làm bài'));
    await tester.pumpAndSettle();
    expect(find.text('Question content'), findsNothing);
    expect(driver.active, isFalse);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    driver.dispose();
  });
  testWidgets('back and navigation stay locked until confirmed submission', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final store = DemoStore();
    await tester.pumpWidget(
      RecallApp(initialRoute: '/student/preview', store: store),
    );
    await tester.pumpAndSettle();
    final navigator = tester.state<NavigatorState>(
      find.byType(Navigator).first,
    );
    store.beginQuiz();
    navigator.pushNamed('/student/quiz');
    await tester.pumpAndSettle();
    expect(find.byType(AppShell), findsNothing);
    expect(store.examInProgress, isTrue);
    expect(find.text('← Quay lại phần xem trước'), findsNothing);
    await tester.tap(find.text('Định danh duy nhất một bản ghi'));
    final context = tester.element(find.byType(FocusedExamScaffold));
    go(context, '/student/documents');
    await navigator.maybePop();
    await tester.pumpAndSettle();
    expect(find.byType(FocusedExamScaffold), findsOneWidget);
    expect(store.answers[0], 0);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nộp bài').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Quay lại'));
    await tester.pumpAndSettle();
    expect(store.submitted, isFalse);
    expect(store.examInProgress, isTrue);
    await tester.tap(find.text('Nộp bài').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Xác nhận nộp bài'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pumpAndSettle();
    expect(store.submitted, isTrue);
    expect(store.examInProgress, isFalse);
    expect(store.lastAnswers[0], 0);
    expect(find.byType(FocusedExamScaffold), findsNothing);
    expect(find.byType(AppShell), findsOneWidget);
    await navigator.maybePop();
    await tester.pumpAndSettle();
    expect(find.byType(FocusedExamScaffold), findsNothing);
    expect(tester.takeException(), isNull);
  });
  testWidgets('assigned exam hides sample answer controls', (tester) async {
    final store = DemoStore()..assignmentQuestions = List.of(sampleQuestions);
    store.beginQuiz(assigned: true);
    store.questionIndex = store.quiz.indexWhere(
      (q) => q.kind == QuestionKind.shortAnswer,
    );
    await tester.pumpWidget(
      RecallApp(initialRoute: '/student/quiz', store: store),
    );
    await tester.pumpAndSettle();
    expect(find.text('Điền câu trả lời mẫu'), findsNothing);
    expect(find.text('Dùng câu trả lời mẫu khác'), findsNothing);
    expect(find.byType(FocusedExamScaffold), findsOneWidget);
  });
}
