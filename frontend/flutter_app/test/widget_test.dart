import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recallai_frontend/design/recall_theme.dart';
import 'package:recallai_frontend/models/demo_store.dart';
import 'package:recallai_frontend/recall_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await DesignAssets.load();
    final font = FontLoader('Inter')
      ..addFont(rootBundle.load('assets/fonts/Inter.ttf'));
    await font.load();
  });
  const routes = [
    '/splash',
    '/register',
    '/login',
    '/onboarding',
    '/role',
    '/student/dashboard',
    '/student/documents',
    '/student/studio',
    '/student/pdf',
    '/student/generator',
    '/student/quiz',
    '/student/results',
    '/student/explanation',
    '/student/decks',
    '/student/flashcards',
    '/student/review',
    '/student/analytics',
    '/student/planner',
    '/student/classes',
    '/student/assigned-quiz',
    '/student/assigned-results',
    '/teacher/dashboard',
    '/teacher/classes',
    '/teacher/classroom',
    '/teacher/generate',
    '/teacher/questions',
    '/teacher/edit',
    '/teacher/builder',
    '/teacher/assign',
    '/teacher/quizzes',
    '/teacher/grading',
    '/teacher/analytics',
    '/teacher/recommendations',
    '/settings',
  ];
  for (final width in [1440.0, 390.0]) {
    for (final route in routes) {
      testWidgets(
        '$route renders at ${width.toInt()}px without layout exceptions',
        (tester) async {
          tester.view.physicalSize = Size(width, 1000);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          await tester.pumpWidget(RecallApp(initialRoute: route));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pumpAndSettle();
        },
      );
    }
  }
  test('mock sample statistics and review dates remain consistent', () {
    final store = DemoStore();
    expect(store.correct, 7);
    expect(store.wrongIndices, [5, 6, 7]);
    expect(store.accuracy, 70);
    store.explain(5);
    store.saveCard(
      store.explained.prompt,
      store.explained.correctText,
      store.explained.explanation,
    );
    expect(store.dueCount, 25);
    store.rate('Khó');
    expect(store.currentCard!.due, DateTime(2026, 11, 12, 9, 10));
    expect(store.dueCount, 24);
    store.reviewAgain(store.currentCard!);
    expect(store.dueCount, 25);
  });
  testWidgets('mistake editor creates an editable card with source identity', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final store = DemoStore()..explain(5);
    await tester.pumpWidget(
      RecallApp(initialRoute: '/student/explanation', store: store),
    );
    await tester.pumpAndSettle();
    final create = find.text('Tạo Flashcard');
    await tester.ensureVisible(create);
    await tester.tap(create);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).first,
      'INNER JOIN giữ lại những dòng nào?',
    );
    final save = find.text('Lưu vào bộ thẻ');
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(store.currentCard!.question.id, 'Q-CSDL-06');
    expect(store.currentCard!.front, 'INNER JOIN giữ lại những dòng nào?');
    expect(find.text('Học bằng Flashcard'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
  testWidgets('quiz keeps answers when moving back and hides grading labels', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final store = DemoStore()..beginQuiz();
    await tester.pumpWidget(
      RecallApp(initialRoute: '/student/quiz', store: store),
    );
    await tester.pumpAndSettle();
    expect(find.text('ĐÁP ÁN ĐÚNG'), findsNothing);
    await tester.tap(find.text('Định danh duy nhất một bản ghi'));
    await tester.tap(find.text('Câu tiếp theo'));
    await tester.pumpAndSettle();
    expect(store.questionIndex, 1);
    await tester.tap(find.text('Câu trước'));
    await tester.pumpAndSettle();
    expect(store.questionIndex, 0);
    expect(store.answers[0], 0);
    expect(find.text('ĐÁP ÁN ĐÚNG'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
