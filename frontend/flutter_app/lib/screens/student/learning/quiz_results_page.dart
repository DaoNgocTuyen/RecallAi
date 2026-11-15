part of '../student_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _StudentQuizResultsPageView on _StudentScreenState {
  Widget _results(DemoStore s) => VStack([
    const Muted('Tổng kết phiên luyện tập · Dữ liệu của riêng bạn.'),
    AdaptiveColumns([
      RecallCard(
        color: RecallColors.mint,
        child: VStack([
          AccuracyRing(s.accuracy),
          SectionTitle('${s.correct} / ${s.lastQuiz.length}', large: true),
          ActionGroup([
            Text(
              '${s.correct}',
              style: const TextStyle(
                color: RecallColors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Muted('đúng'),
            Text(
              '${s.lastQuiz.length - s.correct}',
              style: const TextStyle(
                color: RecallColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Muted('chưa đúng'),
          ]),
          const Muted('Học từ các câu chưa đúng để ghi nhớ tốt hơn.'),
        ]),
      ),
      RecallCard(
        child: VStack([
          const SectionTitle('Học từ các câu chưa đúng'),
          RecallButton(
            'Xem câu trả lời sai',
            onPressed: s.wrongIndices.isEmpty
                ? () => feedback(context, 'Bạn đã trả lời đúng tất cả câu hỏi.')
                : () {
                    s.explain(s.wrongIndices.first);
                    go(context, '/student/explanation');
                  },
          ),
          RecallButton(
            'Tạo bài ôn tập',
            secondary: true,
            onPressed: () => go(context, '/student/generator'),
          ),
          RecallButton(
            'Ôn bằng Flashcard',
            outlined: true,
            onPressed: () => go(context, '/student/decks'),
          ),
          RecallButton(
            'Quay lại Dashboard',
            quiet: true,
            onPressed: () => go(context, '/student/dashboard'),
          ),
        ]),
      ),
    ]),
    RecallCard(
      child: VStack([
        const SectionTitle('Kết quả theo chủ đề'),
        for (final topic in s.lastQuiz.map((q) => q.topic).toSet())
          _topicResult(s, topic),
      ]),
    ),
    const SectionTitle('Xem từng câu trả lời'),
    for (var i = 0; i < s.lastQuiz.length; i++)
      RecallCard(
        onTap: () {
          s.explain(i);
          go(context, '/student/explanation');
        },
        child: VStack([
          Text('Câu ${i + 1} · ${s.lastQuiz[i].prompt}'),
          Pill(
            s.lastAnswers[i] == s.lastQuiz[i].answer ? 'Đúng' : 'Chưa đúng',
            error: s.lastAnswers[i] != s.lastQuiz[i].answer,
          ),
        ]),
      ),
  ], gap: 24);

  Widget _topicResult(DemoStore s, String topic) {
    final indices = List.generate(
      s.lastQuiz.length,
      (i) => i,
    ).where((i) => s.lastQuiz[i].topic == topic).toList();
    final right = indices
        .where((i) => s.lastAnswers[i] == s.lastQuiz[i].answer)
        .length;
    return VStack([
      Wrap(
        spacing: 24,
        runSpacing: 8,
        children: [
          Text(topic),
          Text(
            '$right / ${indices.length} đúng · ${(right * 100 / indices.length).round()}%',
            style: const TextStyle(color: RecallColors.green),
          ),
        ],
      ),
      if (right < indices.length)
        RecallButton(
          'Xem lỗi chủ đề',
          outlined: true,
          onPressed: () {
            s.explain(
              indices.firstWhere(
                (i) => s.lastAnswers[i] != s.lastQuiz[i].answer,
              ),
            );
            go(context, '/student/explanation');
          },
        ),
    ], gap: 8);
  }
}
