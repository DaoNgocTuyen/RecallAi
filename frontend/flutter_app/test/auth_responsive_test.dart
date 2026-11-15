import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recallai_frontend/design/recall_theme.dart';
import 'package:recallai_frontend/recall_app.dart';
import 'package:recallai_frontend/screens/teacher/teacher_screen.dart';
import 'package:recallai_frontend/widgets/recall_widgets.dart';

void main() {
  setUpAll(() async {
    await DesignAssets.load();
    await (FontLoader(
      'Inter',
    )..addFont(rootBundle.load('assets/fonts/Inter.ttf'))).load();
  });
  const sizes = [
    Size(1366, 768),
    Size(1440, 900),
    Size(1920, 1080),
    Size(768, 1024),
    Size(390, 844),
  ];
  for (final size in sizes) {
    for (final route in ['/login', '/role']) {
      testWidgets('$route fits and stays usable at $size', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(RecallApp(initialRoute: route));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final scrolls = tester.stateList<ScrollableState>(
          find.byType(Scrollable),
        );
        if (size.width >= 1000) {
          for (final scroll in scrolls) {
            expect(
              scroll.position.maxScrollExtent,
              0,
              reason: 'Desktop auth content must fit without scrolling',
            );
          }
          for (final button in find.byType(RecallButton).evaluate()) {
            final rect = tester.getRect(find.byWidget(button.widget));
            expect(rect.top, greaterThanOrEqualTo(0));
            expect(rect.bottom, lessThanOrEqualTo(size.height));
          }
        }
        if (route == '/role') {
          final cards = find.byType(RecallCard);
          final first = tester.getRect(cards.first),
              second = tester.getRect(cards.last);
          if (size.width >= 768) {
            expect(first.top, second.top);
            expect(first.right, lessThan(second.left));
          } else {
            expect(first.bottom, lessThan(second.top));
          }
          await tester.ensureVisible(cards.last);
          await tester.tap(cards.last);
          final next = find.byType(RecallButton).first;
          await tester.ensureVisible(next);
          await tester.tap(next);
          await tester.pumpAndSettle();
          expect(find.byType(TeacherScreen), findsOneWidget);
        } else {
          final fields = find.byType(TextFormField);
          await tester.ensureVisible(fields.first);
          await tester.enterText(fields.first, 'student@recallai.test');
          await tester.ensureVisible(fields.last);
          await tester.enterText(fields.last, 'recallai123');
          await tester.tap(find.byType(IconButton).first);
          await tester.pumpAndSettle();
          expect(
            tester
                .widget<EditableText>(find.byType(EditableText).last)
                .obscureText,
            isFalse,
          );
          final login = find.byType(RecallButton).first;
          await tester.ensureVisible(login);
          await tester.tap(login);
          await tester.pumpAndSettle();
          expect(find.byType(RecallCard), findsNWidgets(2));
        }
        expect(tester.takeException(), isNull);
      });
    }
  }
}
