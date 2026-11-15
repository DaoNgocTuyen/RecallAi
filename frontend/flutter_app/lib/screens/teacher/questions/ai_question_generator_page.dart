part of '../teacher_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _TeacherAiQuestionGeneratorPageView on _TeacherScreenState {
  Widget _generate(DemoStore s) => VStack([
    const Muted(
      'Câu hỏi AI gợi ý cần được giáo viên kiểm tra trước khi đưa vào bài kiểm tra.',
    ),
    AdaptiveColumns([
      RecallCard(
        child: VStack([
          const SectionTitle('Nguồn học liệu', large: true),
          const RecallField(
            'Tài liệu',
            initial: 'Cơ sở dữ liệu.pdf',
            readOnly: true,
          ),
          const RecallField('Môn học', initial: 'Cơ sở dữ liệu'),
          const RecallField('Chủ đề', initial: 'SQL JOIN'),
          const RecallField(
            'Yêu cầu bổ sung',
            hint: 'Điều chỉnh nội dung câu hỏi…',
            lines: 3,
          ),
          const Pill('DOC-CSDL-001 · Nội dung mẫu'),
          const SectionTitle('Thiết lập tạo câu hỏi'),
          ActionGroup([
            for (final n in [5, 10, 20, 30])
              ChoiceChip(
                label: Text('$n câu'),
                selected: s.quantity == n,
                onSelected: (_) {
                  s.quantity = n;
                  s.update();
                },
              ),
          ]),
          const RecallField('Độ khó', initial: 'Trung bình'),
          RecallButton(
            busy ? 'Đang tạo câu hỏi…' : 'Tạo câu hỏi bằng AI',
            onPressed: busy
                ? null
                : () async {
                    _refresh(() => busy = true);
                    await Future<void>.delayed(
                      const Duration(milliseconds: 700),
                    );
                    if (!mounted) return;
                    _refresh(() {
                      busy = false;
                      generated = true;
                    });
                  },
          ),
          if (busy)
            const LinearProgressIndicator(color: RecallColors.primaryDark),
        ]),
      ),
      RecallCard(
        child: VStack([
          const SectionTitle('Xem trước câu hỏi gợi ý', large: true),
          const Muted('Hiển thị các câu đại diện trong ngân hàng mẫu.'),
          for (final q in sampleQuestions.where((q) => q.topic == 'SQL JOIN'))
            RecallCard(
              padding: 16,
              color: RecallColors.background,
              child: VStack([
                Pill(
                  s.approvedQuestions.contains(q.id)
                      ? 'Đã duyệt'
                      : 'Chưa duyệt',
                ),
                Text(
                  q.prompt,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Đáp án: ${q.correctText}',
                  style: const TextStyle(color: RecallColors.green),
                ),
                Muted(
                  'Nguồn: Cơ sở dữ liệu.pdf · Trang ${q.page} (mẫu)',
                  small: true,
                ),
                ActionGroup([
                  RecallButton(
                    'Biên tập',
                    outlined: true,
                    onPressed: () {
                      s.editingQuestionId = q.id;
                      go(context, '/teacher/edit');
                    },
                  ),
                  RecallButton(
                    'Duyệt câu hỏi',
                    secondary: true,
                    onPressed: () {
                      s.approvedQuestions.add(q.id);
                      s.update();
                    },
                  ),
                ]),
              ]),
            ),
          RecallButton(
            'Lưu vào ngân hàng câu hỏi',
            onPressed: () {
              feedback(context, 'Đã lưu câu hỏi trong dữ liệu giao diện mẫu.');
              go(context, '/teacher/questions');
            },
          ),
        ]),
      ),
    ]),
  ], gap: 24);
}
