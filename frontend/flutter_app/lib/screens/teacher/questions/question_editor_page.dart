part of '../teacher_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _TeacherQuestionEditorPageView on _TeacherScreenState {
  Widget _edit(DemoStore s) {
    final q = sampleQuestions.firstWhere(
      (q) => q.id == s.editingQuestionId,
      orElse: () => sampleQuestions[5],
    );
    return AdaptiveColumns(
      [
        RecallCard(
          child: VStack([
            const SectionTitle('Nội dung câu hỏi', large: true),
            RecallField(
              'Câu hỏi',
              initial: s.teacherQuestionTitles[q.id] ?? q.prompt,
              lines: 3,
              onChanged: (v) => s.teacherQuestionTitles[q.id] = v,
            ),
            RecallField('Dạng câu hỏi', initial: _kind(q.kind), readOnly: true),
            for (var i = 0; i < q.options.length; i++)
              RecallField(
                'Phương án ${String.fromCharCode(65 + i)}${i == q.answer ? ' · Đáp án mẫu' : ''}',
                initial: q.options[i],
              ),
            RecallField(
              'Giải thích / Tiêu chí chấm',
              initial: q.explanation,
              lines: 3,
            ),
            ActionGroup([
              RecallButton(
                'Lưu thay đổi',
                onPressed: () {
                  s.approvedQuestions.remove(q.id);
                  s.update();
                  feedback(
                    context,
                    'Đã lưu bản biên tập. Câu hỏi cần được duyệt lại.',
                  );
                  go(context, '/teacher/questions');
                },
              ),
              RecallButton(
                'Duyệt câu hỏi',
                secondary: true,
                onPressed: () {
                  s.approvedQuestions.add(q.id);
                  s.update();
                  feedback(context, 'Đã duyệt câu hỏi.');
                },
              ),
              RecallButton(
                'Hủy',
                outlined: true,
                onPressed: () => go(context, '/teacher/questions'),
              ),
            ]),
          ]),
        ),
        RecallCard(
          color: RecallColors.mint,
          child: VStack([
            const SectionTitle('Thông tin nguồn'),
            Text(q.id),
            Text(q.topic),
            Text('Cơ sở dữ liệu.pdf · Trang ${q.page}'),
            const Muted(
              'Nội dung PDF minh họa; cần kiểm chứng với nguồn thật.',
            ),
            const Text(
              'Chỉnh bản nháp không thay đổi phiên bản bài kiểm tra đã giao.',
            ),
          ]),
        ),
      ],
      flex: const [7, 3],
    );
  }
}
