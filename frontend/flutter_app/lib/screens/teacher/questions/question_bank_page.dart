part of '../teacher_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _TeacherQuestionBankPageView on _TeacherScreenState {
  Widget _questions(DemoStore s) => VStack([
    ActionGroup([
      RecallButton(
        'Tạo câu hỏi bằng AI',
        onPressed: () => go(context, '/teacher/generate'),
      ),
      RecallButton(
        'Tạo bài kiểm tra từ câu đã chọn',
        secondary: true,
        onPressed: () => go(context, '/teacher/builder'),
      ),
      Text('${s.selectedQuestions.length} câu đã chọn'),
    ]),
    RecallField(
      'Tìm câu hỏi',
      hint: 'Nội dung, chủ đề…',
      onChanged: (v) => _refresh(() => query = v),
    ),
    ActionGroup([
      for (final f in [
        'Tất cả',
        'Đã duyệt',
        'Chưa duyệt',
        'Trắc nghiệm',
        'Đúng / Sai',
        'Tự luận ngắn',
      ])
        ChoiceChip(
          label: Text(f),
          selected: filter == f,
          onSelected: (_) => _refresh(() => filter = f),
        ),
    ]),
    RecallTable(
      headers: const [
        '',
        'Câu hỏi',
        'Loại',
        'Môn học',
        'Độ khó',
        'Nguồn',
        'Duyệt',
        '',
      ],
      rows: [
        for (final q in sampleQuestions.where(
          (q) =>
              '${q.prompt} ${q.topic}'.toLowerCase().contains(
                query.toLowerCase(),
              ) &&
              (filter == 'Tất cả' ||
                  filter == 'Đã duyệt' && s.approvedQuestions.contains(q.id) ||
                  filter == 'Chưa duyệt' &&
                      !s.approvedQuestions.contains(q.id) ||
                  filter == _kind(q.kind)),
        ))
          [
            Checkbox(
              value: s.selectedQuestions.contains(q.id),
              onChanged: (v) {
                v == true
                    ? s.selectedQuestions.add(q.id)
                    : s.selectedQuestions.remove(q.id);
                s.update();
              },
            ),
            Text(s.teacherQuestionTitles[q.id] ?? q.prompt),
            Text(_kind(q.kind)),
            const Text('Cơ sở dữ liệu'),
            const Text('Trung bình'),
            Text('PDF · Trang ${q.page}'),
            Pill(
              s.approvedQuestions.contains(q.id) ? 'Đã duyệt' : 'Chưa duyệt',
            ),
            TextButton(
              onPressed: () {
                s.editingQuestionId = q.id;
                go(context, '/teacher/edit');
              },
              child: const Text('Sửa'),
            ),
          ],
      ],
    ),
  ], gap: 24);
}
