part of '../student_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _StudentQuestionGeneratorPageView on _StudentScreenState {
  Widget _generator(DemoStore s) => VStack([
    Muted('Từ ${s.source} · Câu hỏi và trang nguồn được dùng làm dữ liệu mẫu.'),
    if (section != 'preview')
      RecallCard(
        child: VStack([
          const Text(
            'Dạng câu hỏi',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          ActionGroup([
            for (final k in QuestionKind.values)
              FilterChip(
                label: Text(_kind(k)),
                selected: s.kinds.contains(k),
                onSelected: (v) {
                  v ? s.kinds.add(k) : s.kinds.remove(k);
                  s.update();
                },
              ),
          ]),
          const Text('Số lượng', style: TextStyle(fontWeight: FontWeight.w600)),
          ActionGroup([
            for (final n in [5, 10, 15, 20])
              ChoiceChip(
                label: Text('$n'),
                selected: s.quantity == n,
                onSelected: (_) {
                  s.quantity = n;
                  s.update();
                },
              ),
          ]),
          const Text('Độ khó', style: TextStyle(fontWeight: FontWeight.w600)),
          ActionGroup([
            for (final d in ['Dễ', 'Trung bình', 'Khó'])
              ChoiceChip(
                label: Text(d),
                selected: s.difficulty == d,
                onSelected: (_) {
                  s.difficulty = d;
                  s.update();
                },
              ),
          ]),
          ActionGroup([
            ChoiceChip(
              label: const Text('Toàn bộ nội dung'),
              selected: subject != 'SQL JOIN',
              onSelected: (_) => _refresh(() => subject = 'Tất cả'),
            ),
            ChoiceChip(
              label: const Text('SQL JOIN'),
              selected: subject == 'SQL JOIN',
              onSelected: (_) => _refresh(() => subject = 'SQL JOIN'),
            ),
          ]),
          RecallButton(
            busy ? 'Đang tạo nội dung mẫu…' : 'Tạo câu hỏi bằng AI',
            onPressed: busy
                ? null
                : () async {
                    if (s.kinds.isEmpty) {
                      feedback(context, 'Chọn ít nhất một dạng câu hỏi.');
                      return;
                    }
                    _refresh(() => busy = true);
                    await Future<void>.delayed(
                      const Duration(milliseconds: 800),
                    );
                    if (!mounted) return;
                    _refresh(() {
                      busy = false;
                      generated = true;
                    });
                    feedback(
                      context,
                      'Đã chuẩn bị bộ câu hỏi mẫu để xem trước.',
                    );
                  },
          ),
          if (busy)
            const LinearProgressIndicator(color: RecallColors.primaryDark),
        ]),
      ),
    RecallCard(
      child: VStack([
        const SectionTitle('Nội dung gợi ý có thể chỉnh sửa'),
        Muted('${s.quantity} câu · ${s.difficulty} · ${s.source}', small: true),
        for (final q in sampleQuestions.take(section == 'preview' ? 5 : 3))
          RecallCard(
            color: RecallColors.background,
            padding: 16,
            child: VStack([
              Pill('${_kind(q.kind)} · ${q.topic}'),
              Text(
                s.questionOverrides[q.id] ?? q.prompt,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Muted(
                s.sourceIsPdf
                    ? '${q.id} · Trang ${q.page} (mẫu)'
                    : '${q.id} · Nguồn văn bản · Không có trang PDF',
                small: true,
              ),
              ActionGroup([
                RecallButton(
                  'Sửa',
                  quiet: true,
                  onPressed: () => _editQuestion(s, q),
                ),
                RecallButton(
                  'Tạo lại',
                  quiet: true,
                  onPressed: () {
                    s.questionOverrides.remove(q.id);
                    s.update();
                    feedback(context, 'Đã khôi phục câu hỏi minh họa.');
                  },
                ),
              ]),
            ]),
          ),
        RecallButton(
          'Bắt đầu luyện tập',
          onPressed: () {
            if (s.kinds.isEmpty) {
              feedback(context, 'Chọn ít nhất một dạng câu hỏi.');
              return;
            }
            _beginExam(s, weakOnly: subject == 'SQL JOIN');
          },
        ),
        const Muted(
          'Đáp án chỉ xuất hiện sau khi nộp ở chế độ tiêu chuẩn.',
          small: true,
        ),
      ]),
    ),
    RecallButton(
      '← Chọn lại nguồn học liệu',
      quiet: true,
      onPressed: () => go(context, '/student/studio'),
    ),
  ], gap: 24);

  Future<void> _editQuestion(DemoStore s, LearningQuestion q) async {
    var value = s.questionOverrides[q.id] ?? q.prompt;
    await recallDialog(
      context,
      'Chỉnh sửa câu hỏi',
      RecallField(
        'Nội dung',
        initial: value,
        lines: 3,
        onChanged: (v) => value = v,
      ),
      actions: [
        RecallButton(
          'Lưu thay đổi',
          onPressed: () {
            if (value.trim().isEmpty) return;
            s.questionOverrides[q.id] = value.trim();
            s.update();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
