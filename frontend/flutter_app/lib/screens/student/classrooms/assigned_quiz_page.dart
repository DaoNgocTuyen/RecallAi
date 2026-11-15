part of '../student_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _StudentAssignedQuizPageView on _StudentScreenState {
  Widget _assignedInstructions(DemoStore s) => AdaptiveColumns(
    [
      RecallCard(
        child: VStack([
          const Pill('BÀI KIỂM TRA DO GIÁO VIÊN QUẢN LÝ'),
          SectionTitle(
            s.assignmentPublished
                ? s.assignmentName
                : 'Kiểm tra chương 2 – SQL',
            large: true,
          ),
          Text(
            '${s.assignmentPublished ? s.assignmentQuestions.length : 20} câu hỏi',
          ),
          Text('${s.assignmentPublished ? s.assignmentMinutes : 30} phút'),
          const Text('Hạn nộp: 20/11/2026 · 22:00'),
          Text(
            '${s.maxAttempts} lượt tối đa · ${s.remainingAttempts} lượt còn lại',
          ),
          Text('Đáp án: ${s.answerPolicy}'),
          const Muted('Không có gợi ý AI hoặc đáp án đúng trong lúc làm bài.'),
          RecallButton(
            'Bắt đầu làm bài',
            onPressed: s.remainingAttempts <= 0
                ? null
                : () {
                    if (!s.assignmentPublished) {
                      s.assignmentQuestions = List.generate(
                        20,
                        (i) => sampleQuestions[i % sampleQuestions.length],
                      );
                    }
                    _beginExam(s, assigned: true);
                  },
          ),
          RecallButton(
            '← Về lớp học',
            outlined: true,
            onPressed: () => go(context, '/student/classes'),
          ),
        ]),
      ),
      const RecallCard(
        color: RecallColors.mint,
        child: VStack([
          SectionTitle('Quy định bài kiểm tra'),
          Text('Chỉ có giáo viên được sửa đề và cấu hình công bố kết quả.'),
          Text('Nộp bài chỉ trừ lượt một lần.'),
          Muted('Đồng hồ và dữ liệu đều là mô phỏng.', small: true),
        ]),
      ),
    ],
    flex: const [7, 3],
  );
}
