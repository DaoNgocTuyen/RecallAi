part of '../student_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _StudentAssignedResultsPageView on _StudentScreenState {
  Widget _assignedResults(DemoStore s) => VStack([
    RecallCard(
      color: RecallColors.mint,
      child: VStack([
        SectionTitle(
          s.assignedSubmitted ? 'Đã nộp bài thành công' : 'Chưa có bài nộp',
          large: true,
        ),
        if (!s.assignedSubmitted)
          const Text('Đọc hướng dẫn để bắt đầu bài được giao.')
        else if (!s.gradeReleased)
          const Text('Đang chờ giáo viên xác nhận và công bố kết quả.')
        else ...[
          Text(
            '${_assignmentGrade(s).toStringAsFixed(1).replaceAll('.', ',')} / 10',
            style: Theme.of(
              context,
            ).textTheme.headlineLarge!.copyWith(color: RecallColors.green),
          ),
          Text(s.feedback.isEmpty ? 'Giáo viên đã trả kết quả.' : s.feedback),
        ],
        Text('${s.remainingAttempts} lượt còn lại'),
        RecallButton(
          'Quay lại lớp học',
          secondary: true,
          onPressed: () => go(context, '/student/classes'),
        ),
        if (s.remainingAttempts > 0)
          RecallButton(
            'Xem hướng dẫn làm bài',
            outlined: true,
            onPressed: () => go(context, '/student/assigned-quiz'),
          ),
      ]),
    ),
    if (s.answersVisible)
      RecallCard(
        child: VStack([
          const SectionTitle('Đáp án được phép xem'),
          for (final q in s.assignmentQuestions)
            VStack([
              Text(
                q.prompt,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                q.correctText,
                style: const TextStyle(color: RecallColors.green),
              ),
              Muted(q.explanation),
            ]),
        ]),
      )
    else
      const Muted(
        'Chỉ hiển thị điểm và đáp án theo quyền công bố của giáo viên.',
      ),
  ], gap: 24);

  double _assignmentGrade(DemoStore s) {
    var objective = 0, max = 0;
    for (var i = 0; i < s.assignmentQuestions.length; i++) {
      final q = s.assignmentQuestions[i];
      max += q.kind == QuestionKind.shortAnswer ? 2 : 1;
      if (q.kind != QuestionKind.shortAnswer &&
          i < s.assignmentAnswers.length &&
          s.assignmentAnswers[i] == q.answer) {
        objective++;
      }
    }
    return max == 0 ? 0 : (objective + (s.manualGrade ?? 0)) / max * 10;
  }
}
