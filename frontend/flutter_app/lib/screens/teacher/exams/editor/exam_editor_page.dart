part of '../../teacher_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _TeacherExamEditorPageView on _TeacherScreenState {
  Widget _builder(DemoStore s) => VStack([
    ActionGroup([
      for (var i = 0; i < 4; i++)
        RecallButton(
          '${i + 1}. ${['Chọn câu hỏi', 'Thông tin bài', 'Cấu hình', 'Xem trước'][i]}',
          secondary: step == i,
          outlined: step != i,
          onPressed: () => _refresh(() => step = i),
        ),
    ]),
    AdaptiveColumns(
      [
        RecallCard(
          child: VStack([
            SectionTitle(
              [
                'Chọn câu hỏi từ ngân hàng',
                'Thông tin bài kiểm tra',
                'Thiết lập quyền làm bài',
                'Xem trước bài kiểm tra',
              ][step],
              large: true,
            ),
            if (step == 0) ...[
              for (final q in sampleQuestions)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(s.teacherQuestionTitles[q.id] ?? q.prompt),
                  subtitle: Text(
                    '${_kind(q.kind)} · ${q.kind == QuestionKind.shortAnswer ? 2 : 1} điểm · ${s.approvedQuestions.contains(q.id) ? 'Đã duyệt' : 'Chưa duyệt'}',
                  ),
                  value: s.selectedQuestions.contains(q.id),
                  onChanged: (v) {
                    v == true
                        ? s.selectedQuestions.add(q.id)
                        : s.selectedQuestions.remove(q.id);
                    s.update();
                  },
                ),
            ] else if (step == 1) ...[
              RecallField(
                'Tên bài kiểm tra',
                initial: s.assignmentName,
                onChanged: (v) {
                  s.assignmentName = v;
                  if (s.activeExam != null) s.activeExam!.title = v;
                },
              ),
              const RecallField('Môn học', initial: 'Cơ sở dữ liệu'),
              const RecallField(
                'Mô tả / Hướng dẫn',
                hint: 'Hướng dẫn học sinh trước khi làm bài…',
                lines: 4,
              ),
            ] else if (step == 2) ...[
              const SectionTitle('Giới hạn thời gian'),
              ActionGroup([
                for (final n in [15, 20, 30])
                  ChoiceChip(
                    label: Text('$n phút'),
                    selected: s.assignmentMinutes == n,
                    onSelected: (_) {
                      s.assignmentMinutes = n;
                      s.update();
                    },
                  ),
              ]),
              const SectionTitle('Số lượt làm bài tối đa'),
              ActionGroup([
                for (final n in [1, 2, 3])
                  ChoiceChip(
                    label: Text('$n lượt'),
                    selected: s.maxAttempts == n,
                    onSelected: (_) {
                      s.maxAttempts = n;
                      s.update();
                    },
                  ),
              ]),
              const RecallField(
                'Thời gian bắt đầu',
                initial: '12/11/2026 · 08:00',
              ),
              const RecallField('Hạn nộp', initial: '20/11/2026 · 22:00'),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Trộn thứ tự câu hỏi và phương án'),
                value: generated,
                onChanged: (v) => _refresh(() => generated = v),
              ),
              const SectionTitle('Học sinh được xem đáp án khi nào?'),
              for (final p in [
                'Sau khi trả kết quả',
                'Sau hạn nộp',
                'Không công bố',
              ])
                ChoiceChip(
                  label: Text(p),
                  selected: s.answerPolicy == p,
                  onSelected: (_) {
                    s.answerPolicy = p;
                    s.update();
                  },
                ),
              const Muted(
                'Tự luận cần được giáo viên xác nhận điểm trước khi trả kết quả hoàn chỉnh.',
              ),
            ] else ...[
              SectionTitle(s.assignmentName),
              Text(
                '${s.selectedQuestions.length} câu · ${s.assignmentMinutes} phút',
              ),
              Text(s.answerPolicy),
              for (final q in sampleQuestions.where(
                (q) => s.selectedQuestions.contains(q.id),
              ))
                RecallCard(
                  color: RecallColors.background,
                  padding: 16,
                  child: Text(s.teacherQuestionTitles[q.id] ?? q.prompt),
                ),
            ],
            ActionGroup([
              if (step > 0)
                RecallButton(
                  '← Quay lại',
                  outlined: true,
                  onPressed: () => _refresh(() => step--),
                ),
              RecallButton(
                step == 3 ? 'Tiếp tục giao bài' : 'Tiếp tục',
                onPressed: () {
                  if (s.selectedQuestions.isEmpty) {
                    feedback(context, 'Chọn ít nhất một câu hỏi.');
                    return;
                  }
                  if (step < 3) {
                    _refresh(() => step++);
                  } else {
                    go(context, '/teacher/assign');
                  }
                },
              ),
              RecallButton(
                'Lưu bản nháp',
                quiet: true,
                onPressed: () => feedback(
                  context,
                  'Đã lưu cấu hình trong phiên giao diện mẫu.',
                ),
              ),
            ]),
          ]),
        ),
        _quizSummary(s),
      ],
      flex: const [31, 15],
    ),
  ], gap: 24);

  Widget _quizSummary(DemoStore s) {
    final selected = sampleQuestions
        .where((q) => s.selectedQuestions.contains(q.id))
        .toList();
    final points = selected.fold(
      0,
      (n, q) => n + (q.kind == QuestionKind.shortAnswer ? 2 : 1),
    );
    return RecallCard(
      color: RecallColors.mint,
      child: VStack([
        const SectionTitle('Tóm tắt bài kiểm tra', large: true),
        Text(
          '${selected.length} câu hỏi',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium!.copyWith(color: RecallColors.green),
        ),
        Text('$points điểm · ${s.assignmentMinutes} phút'),
        Text('${s.maxAttempts} lượt tối đa'),
        Text(
          '${selected.where((q) => s.approvedQuestions.contains(q.id)).length} / ${selected.length} câu đã duyệt',
        ),
        Text(s.answerPolicy),
        const Muted(
          'Chỉ xuất bản sau khi giáo viên kiểm tra và xác nhận đầy đủ.',
          small: true,
        ),
      ]),
    );
  }
}
