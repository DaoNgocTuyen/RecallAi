part of '../teacher_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _TeacherDashboardPageView on _TeacherScreenState {
  Widget _dashboard(DemoStore s) => VStack([
    const Muted(
      'Chào mừng trở lại! Đây là tình hình học tập của các lớp bạn phụ trách.',
    ),
    ActionGroup([
      RecallButton('+ Tạo lớp học', onPressed: () => _createClass(s)),
      RecallButton(
        '✧ Tạo câu hỏi bằng AI',
        secondary: true,
        onPressed: () => go(context, '/teacher/generate'),
      ),
      RecallButton(
        'Tạo bài kiểm tra',
        outlined: true,
        onPressed: () => go(context, '/teacher/builder'),
      ),
    ]),
    AdaptiveGrid(
      [
        Metric(
          '${s.classes.length}',
          'Lớp đang quản lý',
          detail: 'Các lớp được phân quyền',
        ),
        const Metric(
          '128',
          'Học sinh / Sinh viên',
          detail: 'Người học trong không gian',
        ),
        Metric(
          '${12 + s.examDrafts.length + (s.assignmentPublished && !s.examDrafts.any((d) => d.title == s.publishedName) ? 1 : 0)}',
          'Bài kiểm tra',
          detail: 'Trong học kỳ hiện tại',
        ),
        const Metric('86%', 'Tỷ lệ hoàn thành', detail: '110 / 128 người học'),
      ],
      columns: 4,
      minWidth: 200,
    ),
    const AdaptiveColumns([
      RecallCard(
        child: VStack([
          SectionTitle('Tỷ lệ hoàn thành theo lớp'),
          BarChart(
            values: [88, 84, 82, 90],
            labels: ['CSDL K23', 'C#', 'AI', 'CSDL K24'],
          ),
        ]),
      ),
      RecallCard(
        child: VStack([
          SectionTitle('Trạng thái bài nộp'),
          BarChart(
            values: [78, 22, 10],
            labels: ['Đã chấm', 'Chờ chấm', 'Chưa nộp'],
          ),
        ]),
      ),
    ]),
    RecallCard(
      color: RecallColors.mint,
      child: VStack([
        const SectionTitle(
          'RecallAI phát hiện chủ đề SQL JOIN có tỷ lệ trả lời sai cao.',
        ),
        const Muted(
          'Dựa trên 29 / 50 lượt trả lời sai trong dữ liệu mẫu của lớp CSDL K24. Đây chỉ là gợi ý, cần xem lại.',
        ),
        RecallButton(
          'Xem đề xuất',
          outlined: true,
          onPressed: () => go(context, '/teacher/recommendations'),
        ),
      ]),
    ),
    _classTable(s),
  ], gap: 24);
}
