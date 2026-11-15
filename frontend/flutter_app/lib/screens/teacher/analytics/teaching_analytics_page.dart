part of '../teacher_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _TeacherTeachingAnalyticsPageView on _TeacherScreenState {
  Widget _analytics(DemoStore s) => VStack([
    const Muted('Kết quả trong phạm vi lớp được phân quyền · Dữ liệu minh họa'),
    ActionGroup([
      for (final t in ['Lớp học', 'Bài kiểm tra', 'Môn học', 'Khoảng ngày'])
        RecallButton(
          t,
          outlined: true,
          onPressed: () => recallDialog(
            context,
            'Lọc theo $t',
            const RecallField('Phạm vi', initial: 'Cơ sở dữ liệu – K24'),
            actions: [
              RecallButton(
                'Áp dụng',
                onPressed: () {
                  Navigator.pop(context);
                  feedback(context, 'Đã áp dụng bộ lọc dữ liệu mẫu.');
                },
              ),
            ],
          ),
        ),
    ]),
    const AdaptiveGrid(
      [
        Metric('7,8', 'Điểm trung bình'),
        Metric('86%', 'Tỷ lệ hoàn thành'),
        Metric('9,5', 'Điểm cao nhất'),
        Metric('4,0', 'Điểm thấp nhất'),
        Metric('110', 'Bài nộp'),
      ],
      columns: 5,
      minWidth: 160,
    ),
    const AdaptiveColumns([
      RecallCard(
        child: VStack([
          SectionTitle('Phân bố điểm'),
          BarChart(
            values: [4, 10, 36, 40, 20],
            labels: ['<5', '5–6,4', '6,5–7,9', '8–8,9', '9–10'],
          ),
        ]),
      ),
      RecallCard(
        child: VStack([
          SectionTitle('Mức hoàn thành theo lớp'),
          BarChart(
            values: [91, 86, 87, 78],
            labels: ['CSDL K23', 'C#', 'AI', 'CSDL K24'],
          ),
        ]),
      ),
    ]),
    AdaptiveColumns([
      const RecallCard(
        color: RecallColors.mint,
        child: VStack([
          SectionTitle('78% đúng · 22% chưa đúng', large: true),
          Muted('Tỷ lệ câu trả lời trong bộ dữ liệu mẫu.'),
        ]),
      ),
      RecallCard(
        child: VStack([
          const SectionTitle('SQL JOIN · 58% chưa chính xác', large: true),
          const Muted('INNER JOIN: 13 / 25 sai · LEFT JOIN: 16 / 25 sai.'),
          RecallButton(
            'Xem đề xuất ôn tập',
            secondary: true,
            onPressed: () => go(context, '/teacher/recommendations'),
          ),
        ]),
      ),
    ]),
    const RecallCard(
      child: VStack([
        SectionTitle('Điểm trung bình đang cải thiện'),
        Muted('15/10: 6,4 → 22/10: 6,8 → 29/10: 7,1 → 05/11: 7,5 → 11/11: 7,8'),
        AspectRatio(
          aspectRatio: 1080 / 160,
          child: FigmaImage(
            'imgFrame',
            screen: 'T11',
            width: 1080,
            height: 160,
          ),
        ),
      ]),
    ),
    _studentTable(s),
  ], gap: 24);
}
