part of '../student_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _StudentReviewCalendarPageView on _StudentScreenState {
  Widget _review(DemoStore s) => VStack([
    const Muted('Ôn đúng thời điểm để ghi nhớ lâu hơn.'),
    AdaptiveGrid([
      Metric('${s.dueCount} thẻ', 'Thẻ cần ôn hôm nay'),
      Metric(
        '${15 + s.flashcards.where((c) => c.due.isAfter(s.now)).length}',
        'Thẻ sắp đến hạn · 7 ngày',
      ),
      Metric('${156 + s.reviewEvents}', 'Tổng thẻ đã ôn'),
    ]),
    ActionGroup([
      RecallButton(
        'Theo tuần',
        secondary: !monthly,
        outlined: monthly,
        onPressed: () => _refresh(() => monthly = false),
      ),
      RecallButton(
        'Theo tháng',
        secondary: monthly,
        outlined: !monthly,
        onPressed: () => _refresh(() => monthly = true),
      ),
      RecallButton(
        'Bắt đầu ôn tập',
        onPressed: () => go(context, '/student/flashcards'),
      ),
    ]),
    RecallCard(
      child: VStack([
        const SectionTitle('Tháng 11, 2026', large: true),
        Muted('Lịch mẫu · ${timeLabel(s.now)}', small: true),
        AdaptiveGrid(
          [
            for (final n
                in monthly
                    ? List.generate(30, (i) => i + 1)
                    : [9, 10, 11, 12, 13, 14, 15])
              RecallCard(
                padding: 16,
                color: [12, 13, 15].contains(n)
                    ? RecallColors.mint
                    : Colors.white,
                child: VStack([
                  Text(
                    '$n',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  if (n == 12)
                    Text(
                      'Hôm nay · ${s.dueCount} thẻ',
                      style: const TextStyle(fontSize: 12),
                    ),
                  if (n == 13) const Muted('10 thẻ', small: true),
                  if (n == 15) const Muted('2 thẻ', small: true),
                ]),
              ),
          ],
          columns: 7,
          minWidth: 95,
          gap: 12,
        ),
      ]),
    ),
    RecallCard(
      child: VStack([
        const SectionTitle('Buổi ôn theo môn học'),
        for (final (title, detail) in [
          ('Cơ sở dữ liệu', '20 thẻ trong phiên · Khóa và SQL'),
          ('Lập trình C#', '3 thẻ đến hạn · Khái niệm cơ bản'),
          ('REST API', '1 thẻ đến hạn · HTTP và tài nguyên'),
        ])
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(title),
            subtitle: Text(detail),
            trailing: RecallButton(
              'Ôn tập',
              outlined: true,
              onPressed: () => go(context, '/student/flashcards'),
            ),
          ),
      ]),
    ),
    if (s.flashcards.isEmpty)
      EmptyPanel(
        'Chưa có thẻ từ câu cần ôn',
        'Mở một câu sai, biên tập flashcard rồi lưu để bắt đầu lịch ôn.',
        action: RecallButton(
          'Xem phân tích lỗi',
          secondary: true,
          onPressed: () => go(context, '/student/results'),
        ),
      ),
    for (final c in s.flashcards)
      RecallCard(
        child: VStack([
          SectionTitle(c.front),
          Muted('${c.id} · ${c.question.topic} · DOC-CSDL-001', small: true),
          Text(
            'Ôn tiếp: ${timeLabel(c.due)}',
            style: const TextStyle(
              color: RecallColors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
          Pill(c.rating == null ? 'Đến hạn · Chưa ôn' : 'Đã ôn · ${c.rating}'),
          ActionGroup([
            RecallButton(
              'Ôn thẻ',
              secondary: true,
              onPressed: () {
                s.cardIndex = s.flashcards.indexOf(c);
                s.update();
                go(context, '/student/flashcards');
              },
            ),
            RecallButton(
              'Đến lượt ôn (mô phỏng)',
              outlined: true,
              onPressed: () {
                s.reviewAgain(c);
                go(context, '/student/flashcards');
              },
            ),
          ]),
        ]),
      ),
    const Muted(
      'Lịch mô phỏng: Học lại +1 phút · Khó +10 phút · Tốt +1 ngày · Dễ +4 ngày. Chưa sử dụng thuật toán hay thông báo sản xuất.',
      small: true,
    ),
  ], gap: 24);
}
