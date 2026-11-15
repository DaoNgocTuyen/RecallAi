import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recallai_frontend/design/recall_theme.dart';
import 'package:recallai_frontend/models/demo_store.dart';
import 'package:recallai_frontend/models/exam_draft.dart';
import 'package:recallai_frontend/recall_app.dart';
import 'package:recallai_frontend/widgets/recall_widgets.dart';

void main() {
  setUpAll(() async {
    await DesignAssets.load();
    await (FontLoader(
      'Inter',
    )..addFont(rootBundle.load('assets/fonts/Inter.ttf'))).load();
  });
  Future<void> mount(
    WidgetTester tester,
    String route,
    DemoStore store,
    Size size,
  ) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(RecallApp(initialRoute: route, store: store));
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, String label) async {
    final target = find.text(label).last;
    await tester.ensureVisible(target);
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  DemoStore seeded() {
    final store = DemoStore();
    final draft = ExamDraft(id: 'EXAM-TEST')
      ..title = 'Kiểm tra cơ sở dữ liệu'
      ..saved = true
      ..questionIds.addAll(store.selectedQuestions);
    store.activeExam = draft;
    store.examDrafts.add(draft);
    return store;
  }

  for (final size in [
    const Size(1366, 768),
    const Size(1440, 900),
    const Size(1920, 1080),
    const Size(768, 1024),
    const Size(390, 844),
  ]) {
    for (final route in [
      '/teacher/builder',
      '/teacher/exam-config',
      '/teacher/exam-success',
      '/teacher/exam-settings',
      '/teacher/editor',
    ]) {
      testWidgets('$route responsive at $size', (tester) async {
        final store = seeded();
        await mount(tester, route, store, size);
        expect(tester.takeException(), isNull);
        final scroll = find.byType(SingleChildScrollView).first;
        await tester.drag(scroll, const Offset(0, -3000));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
  testWidgets('create, validate, save, configure and reopen the same exam', (
    tester,
  ) async {
    final store = DemoStore();
    await mount(tester, '/teacher/builder', store, const Size(1440, 900));
    await tap(tester, 'Tự soạn Đề thi / Bài tập');
    await tap(tester, 'Lưu');
    expect(store.examDrafts, isEmpty);
    final name = find.descendant(
      of: find.byWidgetPredicate(
        (w) => w is RecallField && w.label == 'Tên đề',
      ),
      matching: find.byType(TextFormField),
    );
    await tester.ensureVisible(name);
    await tester.enterText(name, 'Kiểm tra SQL JOIN');
    await tap(tester, 'Lưu');
    expect(store.examDrafts.length, 1);
    expect(store.activeExam!.title, 'Kiểm tra SQL JOIN');
    final id = store.activeExam!.id;
    await tap(tester, 'Cài đặt làm bài online');
    final shuffle = find.byType(Switch).first;
    await tester.ensureVisible(shuffle);
    await tester.tap(shuffle);
    await tester.pumpAndSettle();
    await tap(tester, 'Bàn phím toán học');
    await tap(tester, 'Khi đạt điểm nhất định');
    await tap(tester, '80%');
    await tap(tester, 'Lưu cài đặt');
    expect(store.activeExam!.id, id);
    expect(store.activeExam!.shuffle, isTrue);
    expect(store.activeExam!.answerThreshold, 80);
    expect(store.activeExam!.keyboards, contains('Bàn phím toán học'));
    expect(store.examDrafts.length, 1);
    await tap(tester, 'Cài đặt làm bài online');
    final toggle = find.byType(Switch).first;
    await tester.ensureVisible(toggle);
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    await tap(tester, 'Hủy');
    expect(
      store.activeExam!.shuffle,
      isTrue,
      reason: 'Cancel must not mutate saved settings',
    );
    await tap(tester, 'Quản lý bài kiểm tra');
    expect(find.text('Kiểm tra SQL JOIN'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('drop rejects unsupported files and keeps accepted source name', (
    tester,
  ) async {
    final store = DemoStore();
    await mount(tester, '/teacher/builder', store, const Size(1440, 900));
    Future<void> drop(String name) async {
      await tester.runAsync(() async {
        tester.widget<DropTarget>(find.byType(DropTarget)).onDragDone!(
          DropDoneDetails(
            files: [
              DropItemFile.fromData(
                Uint8List.fromList([1, 2, 3]),
                name: name,
                path: name,
                length: 3,
              ),
            ],
            localPosition: Offset.zero,
            globalPosition: Offset.zero,
          ),
        );
        await Future<void>.delayed(const Duration(milliseconds: 50));
      });
    }

    await drop('bad.exe');
    await tester.pumpAndSettle();
    expect(store.pendingExam, isNull);
    await drop('Cơ sở dữ liệu.pdf');
    await tester.pumpAndSettle();
    expect(store.pendingExam!.sourceName, 'Cơ sở dữ liệu.pdf');
    expect(find.text('Cơ sở dữ liệu.pdf'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  test('exam question sets and copied settings stay isolated', () {
    final store = seeded();
    final first = store.activeExam!;
    final second = first.copy();
    second.questionIds.clear();
    second.keyboards.clear();
    expect(first.questionIds, isNotEmpty);
    expect(first.keyboards, isNotEmpty);
    store.activeExam = second;
    store.selectedQuestions.add('Q-CSDL-09');
    expect(first.questionIds, isNot(contains('Q-CSDL-09')));
  });
}
