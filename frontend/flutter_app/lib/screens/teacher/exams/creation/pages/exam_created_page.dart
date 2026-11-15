part of '../exam_creation_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _ExamCreationExamCreatedPageView on _ExamCreationScreenState {
  Widget _success(DemoStore store) {
    final draft = store.activeExam;
    if (draft == null) return _empty('Bạn chưa tạo đề nào trong phiên này.');
    return VStack([
      RecallCard(
        color: RecallColors.mint,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 36,
              color: RecallColors.green,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: VStack([
                const SectionTitle('Tạo đề thành công', large: true),
                Text(draft.title),
                if (draft.settingsSaved) const Pill('Đã lưu cài đặt'),
                Muted('${draft.id} · ${draft.grade} · ${draft.subject}'),
                const Muted(
                  'Đã lưu thông tin đề trong phiên. Tiếp tục biên tập câu hỏi và chọn hình thức sử dụng.',
                  small: true,
                ),
              ], gap: 8),
            ),
          ],
        ),
      ),
      _successSection(
        'Online',
        'Thiết lập cách học sinh làm bài trên RecallAI.',
        [
          RecallButton(
            'Cài đặt làm bài online',
            leading: const Icon(Icons.settings_outlined, size: 18),
            onPressed: () => go(context, '/teacher/exam-settings'),
          ),
          RecallButton(
            'Phân tích cấu trúc đề thi',
            outlined: true,
            leading: const Icon(Icons.pie_chart_outline, size: 18),
            onPressed: () => _analysis(store),
          ),
          RecallButton(
            'Biên tập câu hỏi',
            outlined: true,
            onPressed: () => go(context, '/teacher/editor'),
          ),
          RecallButton(
            'Giao cho lớp',
            outlined: true,
            onPressed: () => go(context, '/teacher/assign'),
          ),
        ],
        'Luồng giao bài và ngân hàng câu hỏi hiện có được giữ nguyên. Chưa có link thi công khai hoặc đồng bộ máy chủ.',
      ),
      _successSection(
        'Offline',
        'Chuẩn bị đề cho học sinh làm bài trên giấy.',
        [
          RecallButton(
            'Xem trước đề / Phiếu trả lời',
            outlined: true,
            leading: const Icon(Icons.print_outlined, size: 18),
            onPressed: () => _preview(store, false),
          ),
        ],
        'Xem trước câu hỏi đã chọn trong frontend. Xuất DOCX/PDF và chấm bài từ ảnh cần bổ sung backend.',
      ),
      _successSection(
        'Chèn vào PowerPoint',
        'Chuẩn bị nội dung câu hỏi để trình chiếu trong lớp.',
        [
          RecallButton(
            'Xem trước nội dung slide',
            outlined: true,
            leading: const Icon(Icons.slideshow_outlined, size: 18),
            onPressed: () => _preview(store, true),
          ),
        ],
        'Bản xem trước mô phỏng theo câu hỏi đã chọn; chưa tích hợp PowerPoint hoặc nhận câu trả lời trực tiếp.',
      ),
      ActionGroup([
        RecallButton(
          'Quản lý đề đã tạo',
          secondary: true,
          onPressed: () => go(context, '/teacher/builder'),
        ),
        RecallButton(
          'Quản lý bài kiểm tra',
          outlined: true,
          onPressed: () => go(context, '/teacher/quizzes'),
        ),
        RecallButton(
          'Sao chép mã đề',
          quiet: true,
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: draft.id));
            if (mounted) feedback(context, 'Đã sao chép mã đề ${draft.id}.');
          },
        ),
      ]),
    ], gap: 24);
  }

  Widget _successSection(
    String title,
    String description,
    List<Widget> actions,
    String hint,
  ) => VStack(
    [
      SectionTitle(title, large: true),
      Muted(description),
      RecallCard(
        child: VStack([
          ActionGroup(actions),
          Muted(hint, small: true),
        ], gap: 16),
      ),
    ],
    gap: 12,
    crossAxisAlignment: CrossAxisAlignment.stretch,
  );

  void _analysis(DemoStore store) {
    final questions = sampleQuestions
        .where((q) => store.selectedQuestions.contains(q.id))
        .toList();
    recallDialog(
      context,
      'Cấu trúc đề thi',
      VStack([
        Text('${questions.length} câu hỏi đã chọn từ ngân hàng'),
        for (final kind in QuestionKind.values)
          Text(
            '${switch (kind) {
              QuestionKind.choice => 'Trắc nghiệm',
              QuestionKind.trueFalse => 'Đúng / Sai',
              QuestionKind.shortAnswer => 'Tự luận',
            }}: ${questions.where((q) => q.kind == kind).length} câu',
          ),
        const Muted(
          'Phân tích trực tiếp danh sách câu hỏi mẫu, không phân tích nội dung tệp đính kèm.',
        ),
      ]),
    );
  }

  void _preview(DemoStore store, bool slides) {
    final questions = sampleQuestions
        .where((q) => store.selectedQuestions.contains(q.id))
        .toList();
    recallDialog(
      context,
      slides ? 'Xem trước slide' : 'Xem trước đề và phiếu trả lời',
      VStack([
        SectionTitle(store.activeExam!.title),
        if (questions.isEmpty)
          const Text('Chưa có câu hỏi. Vào Biên tập câu hỏi để thêm nội dung.'),
        for (var i = 0; i < questions.length; i++)
          RecallCard(
            color: RecallColors.background,
            padding: 16,
            child: VStack([
              Text(
                '${slides ? 'Slide' : 'Câu'} ${i + 1}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                store.teacherQuestionTitles[questions[i].id] ??
                    questions[i].prompt,
              ),
              if (!slides)
                const Muted('Trả lời: __________________________________'),
            ], gap: 8),
          ),
      ]),
    );
  }
}
