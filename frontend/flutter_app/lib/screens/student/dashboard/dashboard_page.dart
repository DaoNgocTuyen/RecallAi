part of '../student_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _StudentDashboardPageView on _StudentScreenState {
  Widget _dashboard(DemoStore s) => VStack([
    const Muted('Chào mừng trở lại! Hôm nay bạn muốn học gì?'),
    AdaptiveColumns(
      [
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [RecallColors.mint, RecallColors.cyan],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: RecallColors.border),
          ),
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Expanded(
                child: VStack([
                  const SectionTitle('Học chủ động, nhớ lâu hơn', large: true),
                  const Muted(
                    'Tiếp tục hành trình học tập cùng trợ lý AI của bạn.',
                  ),
                  RecallButton(
                    'Tạo bài học mới',
                    onPressed: () => go(context, '/student/studio'),
                  ),
                ]),
              ),
              const SizedBox(width: 16),
              const RecallRobot(size: 96),
            ],
          ),
        ),
        RecallCard(
          child: VStack([
            const FigmaImage('imgBiuTngClock', width: 28),
            SectionTitle('${s.dueCount} thẻ cần ôn'),
            const Muted('Một phiên ngắn giúp ghi nhớ bền vững.', small: true),
            RecallButton(
              'Ôn tập ngay',
              secondary: true,
              onPressed: () => go(context, '/student/review'),
            ),
          ]),
        ),
      ],
      flex: const [49, 20],
    ),
    AdaptiveGrid(
      [
        Metric('${12 + (s.flashcards.isNotEmpty ? 1 : 0)}', 'Bộ flashcard'),
        Metric('${s.accuracy}%', 'Độ chính xác'),
        Metric('${s.dueCount}', 'Thẻ cần ôn'),
        const Metric('7 ngày', 'Học liên tiếp'),
      ],
      columns: 4,
      minWidth: 180,
    ),
    ActionGroup([
      RecallButton(
        'Tải tài liệu',
        outlined: true,
        onPressed: () => go(context, '/student/upload'),
      ),
      RecallButton(
        'Tạo bài luyện tập',
        outlined: true,
        onPressed: () => go(context, '/student/generator'),
      ),
      RecallButton(
        'Học Flashcard',
        outlined: true,
        onPressed: () => go(context, '/student/decks'),
      ),
      RecallButton(
        'Xem lịch ôn tập',
        outlined: true,
        onPressed: () => go(context, '/student/review'),
      ),
    ]),
    AdaptiveColumns([
      const RecallCard(
        child: VStack([
          SectionTitle('Hoạt động học tập tuần này'),
          BarChart(),
          Muted('Phút học · Bộ dữ liệu mẫu 11/11/2026', small: true),
        ]),
      ),
      RecallCard(
        child: VStack([
          const SectionTitle('Sắp tới trong kế hoạch của bạn'),
          const Text('12/11 · Ôn SQL JOIN · 30 phút'),
          Text('${dateLabel(s.examDate)} · Thi Cơ sở dữ liệu'),
          RecallButton(
            'Xem kế hoạch ôn thi',
            secondary: true,
            onPressed: () => go(context, '/student/planner'),
          ),
        ]),
      ),
    ]),
    RecallCard(
      child: VStack([
        const SectionTitle('Tiếp tục học'),
        const Text('Cơ sở dữ liệu · Tiến độ 65%'),
        const LinearProgressIndicator(
          value: .65,
          minHeight: 8,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          backgroundColor: RecallColors.mint,
          color: RecallColors.primaryDark,
        ),
        RecallButton(
          'Tiếp tục luyện tập',
          onPressed: () => go(context, '/student/generator'),
        ),
      ]),
    ),
    AdaptiveColumns([
      RecallCard(
        child: VStack([
          const SectionTitle('Kiểm tra chương 2 – SQL'),
          const Muted('20 câu · 30 phút · Hạn 20/11/2026', small: true),
          RecallButton(
            'Mở lớp học',
            secondary: true,
            onPressed: () => go(context, '/student/classes'),
          ),
        ]),
      ),
      RecallCard(
        color: RecallColors.mint,
        child: VStack([
          const FigmaImage('imgBiuTngSpark1', screen: 'S08', width: 24),
          const SectionTitle('Ưu tiên ôn SQL JOIN'),
          const Muted('Đề xuất dựa trên kết quả học tập mẫu.'),
          RecallButton(
            'Xem thống kê của bạn',
            outlined: true,
            onPressed: () => go(context, '/student/analytics'),
          ),
        ]),
      ),
    ]),
  ], gap: 24);
}
