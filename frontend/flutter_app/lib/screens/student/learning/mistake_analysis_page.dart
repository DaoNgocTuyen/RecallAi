part of '../student_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _StudentMistakeAnalysisPageView on _StudentScreenState {
  Widget _explanation(DemoStore s) {
    final q = s.explained,
        wrong = s.lastAnswers[s.explanationIndex] != q.answer;
    return VStack([
      AdaptiveColumns([
        RecallCard(
          child: VStack([
            SectionTitle(q.prompt, large: true),
            Pill(wrong ? 'Cần ôn lại' : 'Đã trả lời đúng', error: wrong),
            const Muted('CÂU TRẢ LỜI CỦA BẠN', small: true),
            Text(s.learnerAnswer),
            const Muted('ĐÁP ÁN ĐÚNG', small: true),
            Text(
              q.correctText,
              style: const TextStyle(color: RecallColors.green),
            ),
            Muted('${q.id} · ${q.topic}', small: true),
            RecallButton(
              'Ôn lại chủ đề này',
              secondary: true,
              onPressed: () {
                _beginExam(s, weakOnly: true);
              },
            ),
            RecallButton(
              'Câu sai kế tiếp',
              outlined: true,
              onPressed: () {
                final wrongs = s.wrongIndices;
                if (wrongs.isEmpty) return;
                final pos = wrongs.indexOf(s.explanationIndex);
                s.explain(wrongs[(pos + 1) % wrongs.length]);
              },
            ),
          ]),
        ),
        RecallCard(
          child: VStack([
            const FigmaImage('imgBiuTngSpark1', screen: 'S08', width: 24),
            const SectionTitle('Vì sao đáp án này phù hợp?', large: true),
            Text(q.explanation),
            const Muted(
              'Giải thích do AI gợi ý trong bản mẫu; cần kiểm chứng bằng tài liệu gốc.',
              small: true,
            ),
            if (s.sourceIsPdf && q.page != null)
              RecallCard(
                color: RecallColors.background,
                child: VStack([
                  const SectionTitle('Cơ sở dữ liệu.pdf · Nội dung mẫu'),
                  Text(
                    '${q.page}',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: RecallColors.green,
                    ),
                  ),
                  RecallButton(
                    'Xem tài liệu gốc',
                    outlined: true,
                    onPressed: () {
                      s.explanationIndex = s.lastQuiz.indexOf(q);
                      s.viewerPage = q.page ?? 12;
                      go(context, '/student/pdf');
                    },
                  ),
                  RecallCard(
                    padding: 16,
                    child: VStack([
                      const Muted('TRANG PDF MINH HỌA', small: true),
                      Text(
                        q.explanation,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ]),
                  ),
                ]),
              )
            else
              const Muted('Nguồn văn bản · Chưa có tham chiếu trang PDF.'),
            RecallButton(
              'Tạo Flashcard',
              secondary: true,
              onPressed: () => _cardEditor(s),
            ),
            RecallButton(
              'Thêm vào lịch ôn tập',
              outlined: true,
              onPressed: () => _cardEditor(s),
            ),
          ]),
        ),
      ]),
      RecallButton(
        '← Quay lại kết quả',
        quiet: true,
        onPressed: () => go(context, '/student/results'),
      ),
    ], gap: 24);
  }
}
