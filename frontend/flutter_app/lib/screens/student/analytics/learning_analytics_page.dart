part of '../student_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _StudentLearningAnalyticsPageView on _StudentScreenState {
  Widget _analytics(DemoStore s) => VStack([
    const Muted(
      'Thống kê quan sát từ dữ liệu học tập mẫu; các đề xuất AI được trình bày riêng.',
    ),
    ActionGroup([
      for (final n in [7, 30, 90])
        RecallButton(
          '$n ngày',
          secondary: period == n,
          outlined: period != n,
          onPressed: () => _refresh(() => period = n),
        ),
    ]),
    AdaptiveGrid([
      Metric(
        period == 7
            ? '32'
            : period == 30
            ? '104'
            : '286',
        'Phiên học',
      ),
      Metric('${s.accuracy}%', 'Độ chính xác lần gần nhất'),
      const Metric('7 ngày', 'Học liên tiếp'),
      Metric('${156 + s.reviewEvents}', 'Thẻ đã ôn'),
      Metric('${28 + s.attempts - 1}', 'Bài luyện tập'),
      Metric(
        period == 7
            ? '6h20'
            : period == 30
            ? '24 giờ'
            : '68 giờ',
        'Thời gian học',
      ),
    ]),
    AdaptiveColumns([
      const RecallCard(
        child: VStack([
          SectionTitle('Hoạt động học tập', large: true),
          Muted('Phút học theo các mốc trong kỳ', small: true),
          BarChart(),
        ]),
      ),
      const RecallCard(
        child: VStack([
          SectionTitle('Độ chính xác theo thời gian', large: true),
          Muted('77% → 79% → 81% → 84% → 85%', small: true),
          AspectRatio(
            aspectRatio: 504 / 156,
            child: FigmaImage(
              'imgFrame',
              screen: 'S12',
              width: 504,
              height: 156,
            ),
          ),
          Muted('Biểu đồ lịch sử mẫu trước lượt học gần nhất.', small: true),
        ]),
      ),
    ]),
    RecallCard(
      child: VStack([
        const SectionTitle('Kết quả lượt gần nhất'),
        Text('${s.correct} / ${s.lastQuiz.length} đúng · ${s.accuracy}%'),
        for (final topic in s.lastQuiz.map((q) => q.topic).toSet())
          _topicResult(s, topic),
      ]),
    ),
    AdaptiveGrid([
      for (final (name, value) in [
        ('Cơ sở dữ liệu', '85%'),
        ('Lập trình C#', '78%'),
        ('Nhập môn AI', '91%'),
      ])
        RecallCard(
          child: VStack([
            SectionTitle(name),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineLarge!.copyWith(color: RecallColors.green),
            ),
            const Muted('Lịch sử mẫu', small: true),
          ]),
        ),
    ]),
    RecallCard(
      child: VStack([
        const SectionTitle('Kiến thức cần củng cố', large: true),
        const Muted('Gợi ý từ kết quả trước đây'),
        for (final (name, value, detail) in [
          ('SQL JOIN', '45%', '11 / 20 chưa đúng'),
          ('Entity Framework Core', '62%', '5 / 13 chưa đúng'),
          ('REST API', '78%', '2 / 9 chưa đúng'),
        ])
          RecallCard(
            color: RecallColors.background,
            padding: 16,
            child: VStack([
              SectionTitle('$name · $value', large: true),
              Muted(
                '${name == 'SQL JOIN' ? 'Cơ sở dữ liệu.pdf' : 'Lập trình C#.pdf'} · $detail',
              ),
              ActionGroup([
                RecallButton(
                  'Tạo bài luyện tập',
                  secondary: true,
                  onPressed: () {
                    subject = name;
                    go(context, '/student/generator');
                  },
                ),
                RecallButton(
                  'Ôn bằng Flashcard',
                  outlined: true,
                  onPressed: () => go(context, '/student/decks'),
                ),
              ]),
            ]),
          ),
      ]),
    ),
  ], gap: 24);
}
