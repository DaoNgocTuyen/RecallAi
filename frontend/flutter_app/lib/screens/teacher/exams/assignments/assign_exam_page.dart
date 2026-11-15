part of '../../teacher_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _TeacherAssignExamPageView on _TeacherScreenState {
  Widget _assign(DemoStore s) => VStack([
    const Muted(
      'Chọn lớp được phép nhận bài và xem lại thiết lập trước khi giao.',
    ),
    AdaptiveColumns(
      [
        VStack([
          RecallCard(
            color: RecallColors.mint,
            child: VStack([
              SectionTitle(s.assignmentName, large: true),
              Text(
                '${s.selectedQuestions.length} câu hỏi · ${s.assignmentMinutes} phút',
              ),
            ]),
          ),
          RecallCard(
            child: VStack([
              const SectionTitle('Chọn một hoặc nhiều lớp'),
              for (final c in s.classes)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(c.name),
                  subtitle: Text('${c.code} · ${c.members} người học'),
                  value: s.assignedClasses.contains(c.code),
                  onChanged: (v) {
                    v == true
                        ? s.assignedClasses.add(c.code)
                        : s.assignedClasses.remove(c.code);
                    s.update();
                  },
                ),
            ]),
          ),
          RecallCard(
            child: VStack([
              const SectionTitle('Thiết lập giao bài'),
              const Text('Bắt đầu: 12/11/2026 · 08:00'),
              const Text('Hạn nộp: 20/11/2026 · 22:00'),
              Text('Số lượt: ${s.maxAttempts}'),
              Text('Xem đáp án: ${s.answerPolicy}'),
              const Text('Điểm hiển thị: Sau khi giáo viên duyệt'),
              RecallButton(
                'Điều chỉnh cấu hình',
                outlined: true,
                onPressed: () => go(context, '/teacher/editor'),
              ),
              RecallButton(
                'Xem tóm tắt trước khi giao',
                onPressed: () => _confirmAssignment(s),
              ),
            ]),
          ),
        ]),
        _quizSummary(s),
      ],
      flex: const [31, 15],
    ),
  ], gap: 24);

  void _confirmAssignment(DemoStore s) {
    if (s.assignmentPublished) {
      feedback(context, 'Phiên bản đã giao được giữ nguyên trong bản mẫu.');
      return;
    }
    if (s.selectedQuestions.isEmpty ||
        s.assignedClasses.isEmpty ||
        s.assignmentName.trim().isEmpty) {
      feedback(context, 'Điền tên bài, chọn câu hỏi và chọn lớp nhận bài.');
      return;
    }
    if (s.selectedQuestions.any((id) => !s.approvedQuestions.contains(id))) {
      feedback(context, 'Cần duyệt tất cả câu hỏi trước khi giao.');
      return;
    }
    recallDialog(
      context,
      'Xác nhận giao bài kiểm tra',
      VStack([
        SectionTitle(s.assignmentName),
        Text(
          '${s.selectedQuestions.length} câu · ${s.assignmentMinutes} phút · ${s.maxAttempts} lượt',
        ),
        Text('Lớp nhận bài: ${s.assignedClasses.join(', ')}'),
        Text(s.answerPolicy),
        const Muted(
          'Học sinh chỉ thấy điểm và đáp án theo cấu hình được công bố.',
        ),
      ]),
      actions: [
        RecallButton(
          'Giao bài',
          onPressed: () {
            s.publishAssignment();
            Navigator.pop(context);
            recallDialog(
              context,
              'Giao bài thành công',
              const VStack([
                SectionTitle('SQLJOIN-2026', large: true),
                Text('Bài đã được thêm vào lớp học trong phiên giao diện mẫu.'),
              ]),
              actions: [
                RecallButton(
                  'Quản lý bài kiểm tra',
                  secondary: true,
                  onPressed: () {
                    Navigator.pop(context);
                    go(context, '/teacher/quizzes');
                  },
                ),
                RecallButton(
                  'Xem với sinh viên',
                  outlined: true,
                  onPressed: () {
                    Navigator.pop(context);
                    s.setRole(false);
                    go(context, '/student/classes');
                  },
                ),
              ],
            );
          },
        ),
        RecallButton(
          'Hủy',
          quiet: true,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
