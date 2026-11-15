part of '../student_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _StudentFlashcardDecksPageView on _StudentScreenState {
  Widget _decks(DemoStore s) => VStack([
    const Muted('Các bộ thẻ tiêu biểu trong thư viện của bạn.'),
    ActionGroup([
      for (final t in ['Tất cả', 'Đến hạn hôm nay', 'Học gần đây'])
        ChoiceChip(
          label: Text(t),
          selected: deckFilter == t,
          onSelected: (_) => _refresh(() => deckFilter = t),
        ),
      RecallButton(
        'Tạo bộ Flashcard',
        onPressed: () => go(context, '/student/studio'),
      ),
    ]),
    AdaptiveGrid([
      for (var i = 0; i < 3; i++)
        if (deckFilter != 'Học gần đây' || i < 2)
          RecallCard(
            child: VStack([
              const FigmaImage('imgBiuTngCards', width: 32),
              SectionTitle(
                [
                  'Thuật ngữ Cơ sở dữ liệu',
                  'C# cơ bản',
                  'Khái niệm REST API',
                ][i],
                large: true,
              ),
              Muted(i == 0 ? 'Cơ sở dữ liệu' : 'Lập trình C#'),
              Text('${[48, 32, 20][i]} thẻ · ${[20, 3, 1][i]} thẻ đến hạn'),
              LinearProgressIndicator(
                value: [.65, .45, .2][i],
                color: RecallColors.primaryDark,
                backgroundColor: RecallColors.mint,
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
              ),
              Muted(
                'Ôn gần nhất: ${['11/11/2026', '10/11/2026', '02/11/2026'][i]}',
                small: true,
              ),
              RecallButton(
                'Học bộ thẻ',
                onPressed: () {
                  if (i == 0) {
                    go(context, '/student/flashcards');
                  } else {
                    feedback(
                      context,
                      'Luồng học hoàn chỉnh trong bản mẫu sử dụng bộ Cơ sở dữ liệu.',
                    );
                  }
                },
              ),
              RecallButton(
                '⋯ Quản lý bộ thẻ',
                quiet: true,
                onPressed: () => recallDialog(
                  context,
                  'Quản lý bộ thẻ',
                  RecallField(
                    'Tên bộ thẻ',
                    initial: [
                      'Thuật ngữ Cơ sở dữ liệu',
                      'C# cơ bản',
                      'Khái niệm REST API',
                    ][i],
                  ),
                  actions: [
                    RecallButton(
                      'Lưu',
                      onPressed: () {
                        Navigator.pop(context);
                        feedback(
                          context,
                          'Đã ghi nhận thay đổi trong giao diện mẫu.',
                        );
                      },
                    ),
                    RecallButton(
                      'Tạo thêm thẻ',
                      outlined: true,
                      onPressed: () {
                        Navigator.pop(context);
                        go(context, '/student/studio');
                      },
                    ),
                  ],
                ),
              ),
            ]),
          ),
    ]),
    if (s.flashcards.isNotEmpty)
      RecallCard(
        color: RecallColors.mint,
        child: VStack([
          const SectionTitle('Sai lầm cần ôn · Cơ sở dữ liệu', large: true),
          Text('${s.flashcards.length} thẻ được tạo từ câu cần ôn'),
          for (final c in s.flashcards)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(c.front),
              subtitle: Text(
                '${c.question.id} · ${c.question.topic}\n${timeLabel(c.due)}',
              ),
              isThreeLine: true,
              trailing: RecallButton(
                'Ôn thẻ',
                secondary: true,
                onPressed: () {
                  s.cardIndex = s.flashcards.indexOf(c);
                  s.update();
                  go(context, '/student/flashcards');
                },
              ),
            ),
        ]),
      ),
  ], gap: 24);
}
