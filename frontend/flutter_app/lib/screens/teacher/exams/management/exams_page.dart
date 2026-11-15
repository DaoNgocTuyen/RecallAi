part of '../../teacher_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _TeacherExamsPageView on _TeacherScreenState {
  Widget _quizzes(DemoStore s) => VStack([
    ActionGroup([
      RecallButton(
        'Tạo bài kiểm tra',
        onPressed: () => go(context, '/teacher/builder'),
      ),
      RecallButton(
        'Tất cả',
        secondary: true,
        onPressed: () => _refresh(() => filter = 'Tất cả'),
      ),
      RecallButton(
        'Đang mở',
        outlined: true,
        onPressed: () => _refresh(() => filter = 'Đang mở'),
      ),
      RecallButton(
        'Đã kết thúc',
        outlined: true,
        onPressed: () => _refresh(() => filter = 'Đã kết thúc'),
      ),
    ]),
    RecallField(
      'Tìm bài kiểm tra',
      hint: 'Tên bài kiểm tra…',
      onChanged: (v) => _refresh(() => query = v),
    ),
    _quizTable(s),
  ], gap: 24);

  Widget _quizTable(DemoStore s) => RecallTable(
    headers: const [
      'Bài kiểm tra',
      'Môn / Lớp',
      'Bắt đầu',
      'Hạn nộp',
      'Bài nộp',
      'Trạng thái',
      '',
    ],
    rows: [
      for (final draft in s.examDrafts.where(
        (d) => d.title.toLowerCase().contains(query.toLowerCase()),
      ))
        [
          Text(draft.title),
          Text(draft.subject),
          const Text('—'),
          const Text('—'),
          const Text('0'),
          const Pill('Bản nháp'),
          TextButton(
            onPressed: () {
              s.activeExam = draft;
              s.assignmentName = draft.title;
              s.assignmentMinutes = draft.minutes;
              s.maxAttempts = draft.attempts;
              s.update();
              go(context, '/teacher/exam-success');
            },
            child: const Text('Mở đề'),
          ),
        ],
      if (s.assignmentPublished)
        [
          Text(s.publishedName),
          const Text('Cơ sở dữ liệu – K24'),
          const Text('12/11/2026'),
          const Text('20/11/2026'),
          Text(s.assignedSubmitted ? '1' : '0'),
          const Pill('Đang mở'),
          TextButton(
            onPressed: () => go(context, '/teacher/grading'),
            child: const Text('Bài nộp'),
          ),
        ],
      for (final name in [
        'Kiểm tra chương 2 – SQL',
        'Luyện tập chuẩn hóa dữ liệu',
        'Ôn SQL cơ bản',
      ].where((name) => name.toLowerCase().contains(query.toLowerCase())))
        [
          Text(name),
          const Text('Cơ sở dữ liệu – K24'),
          const Text('11/11/2026'),
          const Text('20/11/2026'),
          const Text('25 / 32'),
          const Pill('Đã giao'),
          TextButton(
            onPressed: () => go(context, '/teacher/grading'),
            child: const Text('⋯'),
          ),
        ],
    ],
  );
}
