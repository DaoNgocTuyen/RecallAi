part of '../student_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _StudentActiveRecallPageView on _StudentScreenState {
  Widget _quiz(DemoStore s) {
    final q = s.quiz[s.questionIndex], index = s.questionIndex;
    return VStack([
      Muted(
        s.assignedMode
            ? 'Bài do giáo viên giao · Không có gợi ý đáp án.'
            : 'Chế độ tiêu chuẩn · Tự nhớ lại trước khi xem lời giải.',
      ),
      AdaptiveColumns(
        [
          RecallCard(
            child: VStack([
              Muted('${index + 1} / ${s.quiz.length}', small: true),
              LinearProgressIndicator(
                value: (index + 1) / s.quiz.length,
                minHeight: 6,
                borderRadius: BorderRadius.circular(6),
                backgroundColor: RecallColors.mint,
                color: RecallColors.primaryDark,
              ),
              SectionTitle(q.prompt, large: true),
              if (q.kind == QuestionKind.shortAnswer) ...[
                RecallField(
                  'Câu trả lời của bạn',
                  key: ValueKey('short-$index'),
                  controller: _answerControllers.putIfAbsent(
                    index,
                    () => TextEditingController(
                      text: s.shortAnswers[index] ?? '',
                    ),
                  ),
                  hint: 'Nhập câu trả lời…',
                  lines: 3,
                  onChanged: s.answerShort,
                  readOnly: s.submitted,
                ),
                if (!s.assignedMode)
                  ActionGroup([
                    RecallButton(
                      'Điền câu trả lời mẫu',
                      quiet: true,
                      onPressed: s.submitted
                          ? null
                          : () {
                              _answerControllers[index]?.text = q.correctText;
                              s.answerShort(q.correctText);
                              _refresh(() {});
                            },
                    ),
                    RecallButton(
                      'Dùng câu trả lời mẫu khác',
                      quiet: true,
                      onPressed: s.submitted
                          ? null
                          : () {
                              _answerControllers[index]?.text = q.options[1];
                              s.answerShort(q.options[1]);
                              _refresh(() {});
                            },
                    ),
                  ]),
              ] else
                for (var j = 0; j < q.options.length; j++)
                  _answerOption(s, q, j),
              const Muted(
                'Đáp án chưa được hiển thị. Nội dung nhập và bộ đếm giờ trong ví dụ được mô phỏng.',
                small: true,
              ),
              ActionGroup([
                RecallButton(
                  'Câu trước',
                  outlined: true,
                  onPressed: index == 0
                      ? null
                      : () {
                          s.questionIndex--;
                          s.update();
                        },
                ),
                RecallButton(
                  index == s.quiz.length - 1 ? 'Nộp bài' : 'Câu tiếp theo',
                  onPressed: () {
                    if (index == s.quiz.length - 1) {
                      _submit(s);
                    } else {
                      s.questionIndex++;
                      s.update();
                    }
                  },
                ),
                RecallButton(
                  'Nộp bài',
                  secondary: true,
                  onPressed: () => _submit(s),
                ),
              ]),
            ]),
          ),
          RecallCard(
            child: VStack([
              const SectionTitle('Phiên luyện tập', large: true),
              Text('${index + 1} / ${s.quiz.length}'),
              const Muted('12:45 · Đồng hồ mẫu', small: true),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var i = 0; i < s.quiz.length; i++)
                    SizedBox(
                      width: 44,
                      height: 44,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: i == index || s.answers[i] != null
                              ? RecallColors.mint
                              : Colors.white,
                          side: const BorderSide(color: RecallColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          s.questionIndex = i;
                          s.update();
                        },
                        child: Text('${i + 1}'),
                      ),
                    ),
                ],
              ),
              Text(
                '${s.answers.where((a) => a != null).length} câu đã trả lời',
              ),
              const Muted(
                'Chọn số câu để quay lại. Đáp án được lưu trong lượt hiện tại.',
                small: true,
              ),
            ]),
          ),
        ],
        flex: const [7, 3],
      ),
    ], gap: 24);
  }

  Widget _answerOption(DemoStore s, LearningQuestion q, int j) => InkWell(
    onTap: s.submitted ? null : () => s.answer(j),
    borderRadius: BorderRadius.circular(16),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: s.answers[s.questionIndex] == j
            ? RecallColors.mint
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: s.answers[s.questionIndex] == j
              ? RecallColors.green
              : RecallColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${String.fromCharCode(65 + j)}.',
            style: const TextStyle(color: RecallColors.green),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(q.options[j])),
        ],
      ),
    ),
  );

  void _submit(DemoStore s) {
    if (_submitting || s.submitted || _examFullscreen?.active == false) return;
    final unanswered = s.answers.where((a) => a == null).length;
    recallDialog(
      context,
      s.assignedMode ? 'Nộp bài kiểm tra?' : 'Nộp bài luyện tập?',
      VStack([
        Text(
          unanswered == 0
              ? 'Bạn đã trả lời tất cả câu hỏi.'
              : 'Còn $unanswered câu chưa trả lời.',
        ),
        const Muted(
          'Các câu chưa trả lời được tính là chưa đúng. Sau khi nộp bạn có thể xem đáp án và giải thích.',
        ),
      ]),
      actions: [
        RecallButton(
          'Xác nhận nộp bài',
          onPressed: () {
            _finishExamSubmission(s);
          },
        ),
        RecallButton(
          'Quay lại',
          outlined: true,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
