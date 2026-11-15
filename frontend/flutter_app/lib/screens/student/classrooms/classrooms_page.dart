part of '../student_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _StudentClassroomsPageView on _StudentScreenState {
  Widget _classes(DemoStore s) {
    final joined = s.classes.where((c) => c.joined).toList(),
        current = s.classes[s.selectedClass.clamp(0, s.classes.length - 1)];
    return VStack([
      const Muted('Lớp đã tham gia, bài được giao và kết quả được phép xem.'),
      ActionGroup([
        RecallButton('Tham gia lớp học', onPressed: () => _joinClass(s)),
        Text('${joined.length} lớp đang học'),
      ]),
      AdaptiveColumns(
        [
          RecallCard(
            padding: 16,
            child: VStack([
              for (final c in joined)
                RecallCard(
                  padding: 16,
                  color: RecallColors.background,
                  onTap: () {
                    s.selectedClass = s.classes.indexOf(c);
                    s.update();
                  },
                  child: VStack([
                    const FigmaImage('imgBiuTngCap'),
                    SectionTitle(c.name),
                    Muted(c.teacher, small: true),
                    const Muted('Xem thông tin lớp →', small: true),
                  ]),
                ),
            ]),
          ),
          RecallCard(
            child: VStack([
              SectionTitle(current.name, large: true),
              Muted(current.teacher),
              ActionGroup([
                Text(
                  current.code,
                  style: const TextStyle(color: RecallColors.green),
                ),
                Text('${current.members} sinh viên'),
              ]),
              ActionGroup([
                for (final tab in ['Tổng quan', 'Bài kiểm tra', 'Kết quả'])
                  RecallButton(
                    tab,
                    secondary: classTab == tab,
                    outlined: classTab != tab,
                    onPressed: () => _refresh(() => classTab = tab),
                  ),
              ]),
              if (classTab == 'Tổng quan')
                const RecallCard(
                  color: RecallColors.mint,
                  padding: 16,
                  child: Text('Ôn lại SQL JOIN trước bài kiểm tra ngày 20/11.'),
                ),
              if (classTab != 'Kết quả')
                RecallCard(
                  padding: 16,
                  child: VStack([
                    const SectionTitle('Kiểm tra chương 2 – SQL'),
                    const Muted(
                      '20 câu hỏi · 30 phút · Hạn 20/11/2026 · 2 lượt nộp tối đa',
                      small: true,
                    ),
                    Text(
                      '${s.remainingAttempts} lượt',
                      style: const TextStyle(color: RecallColors.green),
                    ),
                    RecallButton(
                      'Đọc hướng dẫn và làm bài',
                      onPressed: () => go(context, '/student/assigned-quiz'),
                    ),
                    RecallButton(
                      'Xem kết quả đã nộp',
                      outlined: true,
                      onPressed: () => go(context, '/student/assigned-results'),
                    ),
                  ]),
                ),
              if (s.assignmentPublished && classTab != 'Kết quả')
                RecallCard(
                  color: RecallColors.mint,
                  padding: 16,
                  child: VStack([
                    SectionTitle(s.assignmentName),
                    Text(
                      '${s.assignmentQuestions.length} câu · ${s.assignmentMinutes} phút · ${{true: 'Đã giao'}[true]}',
                    ),
                    RecallButton(
                      'Mở bài được giao',
                      secondary: true,
                      onPressed: () => go(context, '/student/assigned-quiz'),
                    ),
                  ]),
                ),
              RecallCard(
                child: VStack([
                  const SectionTitle('Lịch sử bài nộp của bạn'),
                  RecallButton(
                    'Ôn SQL cơ bản · 9,0 / 10 · Đã công bố',
                    secondary: true,
                    onPressed: () => recallDialog(
                      context,
                      'Kết quả đã công bố',
                      const VStack([
                        SectionTitle('9,0 / 10', large: true),
                        Text('18 / 20 câu đúng'),
                        Text('Giáo viên đã cho phép xem đáp án và lời giải.'),
                        Text('INNER JOIN: Các dòng khớp điều kiện nối.'),
                      ]),
                    ),
                  ),
                  RecallButton(
                    'Bài tự luận chương 1 · Chờ chấm',
                    outlined: true,
                    onPressed: () => recallDialog(
                      context,
                      'Bài đang chờ chấm',
                      const Text(
                        'Giáo viên chưa xác nhận điểm và chưa công bố đáp án.',
                      ),
                    ),
                  ),
                ]),
              ),
              if (s.reviewAssigned)
                RecallCard(
                  color: RecallColors.mint,
                  child: VStack([
                    const SectionTitle('Ôn tập SQL JOIN · Hoạt động được giao'),
                    const Text('Đề xuất đã được giáo viên duyệt.'),
                    RecallButton(
                      'Bắt đầu ôn tập',
                      onPressed: () {
                        _beginExam(s, weakOnly: true);
                      },
                    ),
                  ]),
                ),
              const Muted(
                'Bạn không thể thay đổi câu hỏi hay cấu hình của giáo viên. Đáp án chỉ hiện khi được công bố.',
                small: true,
              ),
            ]),
          ),
        ],
        flex: const [3, 8],
      ),
    ], gap: 24);
  }

  Future<void> _joinClass(DemoStore s) async {
    var code = '', preview = false, error = '';
    await recallDialog(
      context,
      'Tham gia lớp học',
      StatefulBuilder(
        builder: (context, setLocal) {
          final index = s.classes.indexWhere((c) => c.code == code);
          return VStack([
            RecallField(
              'Mã mời của giáo viên',
              hint: 'VD: RECALL-1234',
              onChanged: (v) => code = v.trim().toUpperCase(),
            ),
            const Muted('Mã lớp mẫu: RECALL-1234', small: true),
            if (error.isNotEmpty)
              Text(error, style: const TextStyle(color: RecallColors.error)),
            if (preview)
              RecallCard(
                color: RecallColors.mint,
                child: VStack([
                  SectionTitle(
                    index >= 0
                        ? s.classes[index].name
                        : 'Cơ sở dữ liệu · Nhóm B',
                  ),
                  const Text('Giáo viên: Nguyễn Văn A'),
                  Text(
                    index >= 0
                        ? '${s.classes[index].members} thành viên'
                        : '35 thành viên',
                  ),
                  Text('Mã lớp: $code'),
                  RecallButton(
                    'Xác nhận tham gia',
                    onPressed: () {
                      if (index >= 0) {
                        final c = s.classes[index];
                        if (!c.joined) {
                          c.joined = true;
                          c.members++;
                        }
                      } else {
                        s.joinClass(code);
                      }
                      s.update();
                      Navigator.pop(context);
                      feedback(this.context, 'Tham gia lớp thành công.');
                    },
                  ),
                ]),
              ),
            RecallButton(
              'Tìm lớp',
              onPressed: () => setLocal(() {
                preview = code == 'RECALL-1234' || index >= 0;
                error = preview
                    ? ''
                    : 'Không tìm thấy lớp. Hãy kiểm tra lại mã mời.';
              }),
            ),
          ]);
        },
      ),
    );
  }
}
