part of '../teacher_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _TeacherClassroomDetailsPageView on _TeacherScreenState {
  Widget _classroom(DemoStore s) {
    final c = s.classes[s.selectedClass];
    return VStack([
      RecallCard(
        color: RecallColors.mint,
        child: AdaptiveColumns(
          [
            VStack([
              SectionTitle(c.name, large: true),
              Text('${c.teacher} · Cộng tác: Nguyễn Văn A'),
              const Muted('Ôn mô hình quan hệ, SQL và các phép nối bảng.'),
            ]),
            VStack([
              Text(
                c.code,
                style: const TextStyle(
                  color: RecallColors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SectionTitle('${c.members}'),
              const Muted('học sinh / sinh viên', small: true),
              RecallButton(
                'Sao chép mã mời',
                outlined: true,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: c.code));
                  feedback(context, 'Đã sao chép mã mời.');
                },
              ),
            ]),
          ],
          flex: const [7, 3],
        ),
      ),
      ActionGroup([
        for (final t in ['Tổng quan', 'Thành viên', 'Bài kiểm tra', 'Kết quả'])
          RecallButton(
            t,
            secondary: tab == t,
            quiet: tab != t,
            onPressed: () => _refresh(() => tab = t),
          ),
      ]),
      ActionGroup([
        RecallButton(
          'Giao bài kiểm tra',
          onPressed: () => go(context, '/teacher/assign'),
        ),
        RecallButton(
          'Xem thống kê lớp',
          outlined: true,
          onPressed: () => go(context, '/teacher/analytics'),
        ),
      ]),
      if (tab == 'Tổng quan')
        AdaptiveColumns([
          const RecallCard(
            child: VStack([
              SectionTitle('Hoạt động gần đây'),
              Text('Nguyễn Minh Anh đã nộp bài SQL.'),
              Muted('Hôm nay · 14:25', small: true),
            ]),
          ),
          RecallCard(
            child: VStack([
              const SectionTitle('Kiểm tra chương 2 – SQL'),
              const Muted('20/11/2026 · 25 / 32 bài đã nộp', small: true),
              RecallButton(
                'Xem bài nộp',
                secondary: true,
                onPressed: () => go(context, '/teacher/grading'),
              ),
            ]),
          ),
        ]),
      if (tab == 'Bài kiểm tra') _quizTable(s) else _studentTable(s),
      RecallButton(
        '← Về danh sách lớp',
        quiet: true,
        onPressed: () => go(context, '/teacher/classes'),
      ),
    ], gap: 24);
  }

  Widget _studentTable(DemoStore s) => RecallTable(
    headers: const [
      'Học sinh / Sinh viên',
      'Mã số',
      'Tham gia',
      'Hoàn thành',
      'Kết quả học',
      'Xu hướng',
      '',
    ],
    rows: [
      for (var i = 0; i < 8; i++)
        [
          Text(_names[i]),
          Text('23110${i + 7}'),
          const Text('03/11/2026'),
          Text('${[86, 92, 75, 67, 83, 75, 100, 58][i]}%'),
          Text(
            '${[8.5, 9, 7.5, 6.8, 8.2, 7, 9.5, 4][i].toStringAsFixed(1)} / 10',
          ),
          Pill(i == 7 ? 'Cần hỗ trợ' : 'Đang tiến bộ'),
          TextButton(
            onPressed: () => recallDialog(
              context,
              _names[i],
              const Text('Thông tin người học trong lớp · Dữ liệu minh họa.'),
            ),
            child: const Text('⋯'),
          ),
        ],
    ],
  );
  static const _names = [
    'Nguyễn Minh Anh',
    'Trần Quốc Bảo',
    'Lê Thu Hà',
    'Phạm Gia Hân',
    'Võ Đức Minh',
    'Nguyễn Tuấn Kiệt',
    'Đỗ Ngọc Lan',
    'Hoàng An Nhiên',
  ];
}
