part of '../exam_creation_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _ExamCreationExamConfigurationPageView on _ExamCreationScreenState {
  Widget _configuration(DemoStore store) {
    final draft = _editing(store);
    return Form(
      key: formKey,
      child: VStack([
        ActionGroup([
          Pill(draft.method.online ? 'Online' : 'Offline'),
          Pill(draft.method.title),
        ]),
        if (draft.sourceName.isNotEmpty)
          RecallCard(
            color: RecallColors.mint,
            padding: 16,
            child: Row(
              children: [
                const Icon(Icons.attach_file, color: RecallColors.green),
                const SizedBox(width: 12),
                Expanded(
                  child: VStack([
                    Text(draft.sourceName),
                    const Muted(
                      'Đã chọn tệp · Chưa nhập nội dung câu hỏi',
                      small: true,
                    ),
                  ], gap: 4),
                ),
              ],
            ),
          ),
        RecallCard(
          child: VStack([
            RecallField(
              'Tên đề',
              controller: _controller('title', draft.title),
              hint: 'Ví dụ: Kiểm tra giữa kỳ – Cơ sở dữ liệu',
              onChanged: (v) => draft.title = v,
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Vui lòng nhập tên đề.'
                  : null,
            ),
            AdaptiveColumns([
              _select('Khối học', draft.grade, [
                'Đại học',
                'Cao đẳng',
                'Khối 12',
                'Khối 11',
                'Khối 10',
                'Khối 9',
                'Khối 8',
                'Khối 7',
                'Khối 6',
                'Khối 5',
              ], (v) => draft.grade = v),
              _select('Môn học', draft.subject, [
                'Cơ sở dữ liệu',
                'Lập trình C#',
                'Nhập môn AI',
                'Toán học',
                'Công nghệ',
                'Tiếng Anh',
                'Khác',
              ], (v) => draft.subject = v),
            ], breakpoint: 650),
            _select('Mục đích tạo đề', draft.purpose, [
              'Luyện tập / Ôn tập',
              'Kiểm tra giữa kỳ I',
              'Kiểm tra cuối kỳ I',
              'Kiểm tra giữa kỳ II',
              'Kiểm tra cuối kỳ II',
              'Đánh giá năng lực',
            ], (v) => draft.purpose = v),
            _pricing(draft),
            RecallField(
              'Mô tả',
              controller: _controller('description', draft.description),
              hint: 'Nhập mô tả…',
              lines: 4,
              onChanged: (v) => draft.description = v,
            ),
            if (draft.method == ExamMethod.offlineText)
              RecallField(
                'Nội dung đề bằng Text',
                controller: _controller('sourceText', draft.sourceText),
                hint: 'Nhập hoặc dán nội dung câu hỏi…',
                lines: 6,
                onChanged: (v) => draft.sourceText = v,
              ),
            if (draft.method == ExamMethod.matrix ||
                draft.method == ExamMethod.competency)
              const RecallCard(
                color: RecallColors.mint,
                padding: 16,
                child: Muted(
                  'Sau khi lưu thông tin, chọn câu hỏi theo chủ đề trong ngân hàng RecallAI. Sinh đề tự động từ ma trận là chức năng backend sẽ bổ sung sau.',
                ),
              ),
          ], gap: 24),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: ActionGroup([
            RecallButton(
              'Hủy',
              outlined: true,
              onPressed: () => go(context, '/teacher/builder'),
            ),
            RecallButton(
              'Lưu',
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                draft.title = draft.title.trim();
                draft.saved = true;
                final index = store.examDrafts.indexWhere(
                  (e) => e.id == draft.id,
                );
                if (index < 0) {
                  store.examDrafts.add(draft);
                } else {
                  store.examDrafts[index] = draft;
                }
                store.activeExam = draft;
                store.pendingExam = null;
                store.assignmentName = draft.title;
                store.update();
                go(context, '/teacher/exam-success');
              },
            ),
          ]),
        ),
      ], gap: 24),
    );
  }
}
