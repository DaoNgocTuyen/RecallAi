part of '../teacher_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _TeacherGradingPageView on _TeacherScreenState {
  Widget _grading(DemoStore s) {
    final actual = s.assignedSubmitted,
        maxShort = actual ? s.assignmentShortMaximum : 2,
        objective = actual ? s.assignmentObjective : 8,
        total = actual ? s.assignmentMaximum : 10;
    final grade = total == 0
        ? 0
        : (objective + (s.manualGrade ?? 0)) / total * 10;
    final prompt =
        actual &&
            s.assignmentQuestions.any((q) => q.kind == QuestionKind.shortAnswer)
        ? s.assignmentQuestions
              .firstWhere((q) => q.kind == QuestionKind.shortAnswer)
              .prompt
        : 'INNER JOIN xử lý các dòng không khớp như thế nào?';
    return VStack([
      const Muted(
        'AI chỉ đưa ra gợi ý; giáo viên chịu trách nhiệm xác nhận điểm và phản hồi cuối cùng.',
      ),
      AdaptiveColumns(
        [
          RecallCard(
            child: VStack([
              const SectionTitle('Bài nộp trong lớp được phép'),
              for (final (name, status) in [
                (
                  'Nguyễn Minh Anh',
                  s.gradeReleased ? 'Đã trả kết quả' : 'Chờ chấm',
                ),
                ('Trần Quốc Bảo', 'Đã chấm'),
                ('Lê Thu Hà', 'Đang chấm'),
              ])
                RecallCard(
                  color: name == 'Nguyễn Minh Anh'
                      ? RecallColors.mint
                      : Colors.white,
                  padding: 16,
                  child: VStack([
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(actual ? s.publishedName : 'Kiểm tra chương 2 – SQL'),
                    const Muted('CSDL K24 · 11/11 · 14:25', small: true),
                    Pill(status),
                  ]),
                ),
              const Muted(
                'Chỉ bài nộp trong các lớp được phân quyền.',
                small: true,
              ),
            ]),
          ),
          RecallCard(
            child: VStack([
              const SectionTitle('Bài làm của Nguyễn Minh Anh', large: true),
              const Pill('Dữ liệu minh họa'),
              const SectionTitle('Điểm câu khách quan'),
              SectionTitle(
                '$objective / ${total - maxShort} điểm tự động',
                large: true,
              ),
              const Muted(
                'Điểm tự động căn cứ đáp án của phiên bản bài đã giao.',
                small: true,
              ),
              if (maxShort > 0)
                RecallCard(
                  color: RecallColors.background,
                  padding: 16,
                  child: VStack([
                    SectionTitle(prompt),
                    const Muted('CÂU TRẢ LỜI CỦA HỌC SINH', small: true),
                    const Text('Giữ các dòng khớp điều kiện nối.'),
                    Text(
                      'AI gợi ý: ${(maxShort / 4).toStringAsFixed(1)} / $maxShort điểm',
                      style: const TextStyle(color: RecallColors.green),
                    ),
                    const Muted(
                      'Gợi ý AI chỉ để tham khảo; có thể chưa chính xác.',
                      small: true,
                    ),
                    RecallButton(
                      'Áp dụng gợi ý AI',
                      outlined: true,
                      onPressed: () {
                        s.manualGrade = maxShort / 4;
                        s.gradeConfirmed = false;
                        s.update();
                      },
                    ),
                    const Muted(
                      'Điều kiện khớp: 1 điểm. Giải thích loại bỏ dòng không khớp: 1 điểm.',
                      small: true,
                    ),
                    const Text(
                      'Điểm do giáo viên quyết định',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    ActionGroup([
                      for (var i = 0; i <= 4; i++)
                        RecallButton(
                          (maxShort * i / 4).toString().replaceAll('.', ','),
                          secondary: true,
                          compact: true,
                          onPressed: () {
                            s.manualGrade = maxShort * i / 4;
                            s.gradeConfirmed = false;
                            s.update();
                          },
                        ),
                    ]),
                    Text(
                      s.manualGrade == null
                          ? 'Chưa chọn điểm'
                          : '${s.manualGrade} / $maxShort điểm',
                      style: const TextStyle(color: RecallColors.green),
                    ),
                  ]),
                ),
            ]),
          ),
          RecallCard(
            child: VStack([
              const SectionTitle('Kết quả chấm'),
              Text(
                s.gradeConfirmed ? 'Đã chấm' : 'Chờ chấm',
                style: const TextStyle(color: RecallColors.green),
              ),
              SectionTitle(
                s.gradeConfirmed
                    ? '${grade.toStringAsFixed(1).replaceAll('.', ',')} / 10'
                    : 'Chưa xác nhận',
                large: true,
              ),
              RecallField(
                'Phản hồi của giáo viên',
                initial: s.feedback,
                lines: 4,
                onChanged: (v) => s.feedback = v,
              ),
              RecallButton(
                'Lưu điểm',
                outlined: true,
                onPressed: () =>
                    feedback(context, 'Đã lưu điểm nháp, chưa trả kết quả.'),
              ),
              RecallButton(
                'Xác nhận chấm',
                onPressed: () {
                  if (maxShort > 0 && s.manualGrade == null) {
                    feedback(context, 'Chọn điểm tự luận trước khi xác nhận.');
                    return;
                  }
                  s.gradeConfirmed = true;
                  s.update();
                },
              ),
              RecallButton(
                'Trả kết quả',
                secondary: true,
                onPressed: () {
                  if (!s.gradeConfirmed) {
                    feedback(
                      context,
                      'Cần xác nhận điểm trước khi trả kết quả.',
                    );
                    return;
                  }
                  s.gradeReleased = true;
                  s.update();
                  feedback(context, 'Đã công bố kết quả theo cấu hình mẫu.');
                },
              ),
              const Muted(
                'Điểm gợi ý không tự động trở thành điểm chính thức.',
                small: true,
              ),
            ]),
          ),
        ],
        flex: const [12, 22, 11],
        breakpoint: 950,
      ),
    ], gap: 24);
  }
}
