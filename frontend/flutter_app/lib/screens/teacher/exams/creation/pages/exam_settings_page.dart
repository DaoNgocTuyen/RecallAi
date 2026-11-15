part of '../exam_creation_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _ExamCreationExamSettingsPageView on _ExamCreationScreenState {
  Widget _settings(DemoStore store) {
    if (store.activeExam == null) {
      return _empty('Tạo đề trước khi thiết lập cách làm bài.');
    }
    final draft = editing ??= store.activeExam!.copy();
    return VStack([
      SectionTitle(draft.title, large: true),
      const Muted(
        'Các tùy chọn được lưu trong phiên mô phỏng, chưa áp dụng cho lượt thi thực tế.',
      ),
      _settingsCard('Thời gian và lượt làm bài', [
        _settingRow(
          'Thời gian làm bài',
          'Số phút cho mỗi lượt làm bài.',
          _choices(
            '${draft.minutes} phút',
            ['15 phút', '20 phút', '30 phút', '45 phút', '60 phút'],
            (v) => draft.minutes = int.parse(v.split(' ').first),
          ),
        ),
        _settingRow(
          'Số lượt làm bài tối đa',
          'Giới hạn số lần người học được làm bài.',
          _choices(
            '${draft.attempts} lượt',
            ['1 lượt', '2 lượt', '3 lượt'],
            (v) => draft.attempts = int.parse(v.split(' ').first),
          ),
        ),
      ]),
      _settingsCard('Đảo câu hỏi và đáp án', [
        _toggle(
          'Đảo câu hỏi và đáp án',
          'Mô phỏng đảo thứ tự câu hỏi và các phương án trong mỗi lần học sinh vào làm bài.',
          draft.shuffle,
          (v) => draft.shuffle = v,
        ),
        _toggle(
          'Ẩn tiêu đề nhóm',
          'Ẩn tiêu đề các nhóm câu hỏi khi làm bài online hoặc chuẩn bị đề offline.',
          draft.hideGroups,
          (v) => draft.hideGroups = v,
        ),
      ]),
      _settingsCard('Cấu hình bàn phím nhập liệu', [
        _settingRow(
          'Loại bàn phím nhập đáp án',
          'Có thể chọn nhiều loại. Giữ ít nhất một bàn phím cho câu tự luận và câu điền từ.',
          LayoutBuilder(
            builder: (context, c) => Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final (label, icon, description) in [
                  (
                    'Bàn phím cơ bản',
                    Icons.keyboard_outlined,
                    'Nhập văn bản thông thường',
                  ),
                  (
                    'Bàn phím toán học',
                    Icons.functions,
                    'Nhập công thức toán học',
                  ),
                  (
                    'Soạn thảo văn bản',
                    Icons.text_fields,
                    'Định dạng văn bản phong phú',
                  ),
                ])
                  SizedBox(
                    width: c.maxWidth >= 560
                        ? (c.maxWidth - 24) / 3
                        : c.maxWidth,
                    child: Semantics(
                      selected: draft.keyboards.contains(label),
                      button: true,
                      child: RecallCard(
                        padding: 16,
                        color: draft.keyboards.contains(label)
                            ? RecallColors.mint
                            : Colors.white,
                        onTap: () => _refresh(() {
                          if (draft.keyboards.contains(label)) {
                            if (draft.keyboards.length > 1) {
                              draft.keyboards.remove(label);
                            } else {
                              feedback(
                                context,
                                'Giữ ít nhất một loại bàn phím.',
                              );
                            }
                          } else {
                            draft.keyboards.add(label);
                          }
                        }),
                        child: VStack([
                          Row(
                            children: [
                              Icon(icon, color: RecallColors.green),
                              const Spacer(),
                              if (draft.keyboards.contains(label))
                                const Icon(
                                  Icons.check_circle,
                                  color: RecallColors.green,
                                  size: 20,
                                ),
                            ],
                          ),
                          Text(
                            label,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Muted(description, small: true),
                        ], gap: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ]),
      _settingsCard('Điểm và đáp án khi làm xong', [
        _settingRow(
          'Cho xem điểm',
          'Thời điểm hiển thị điểm cho học sinh.',
          _choices(draft.scoreVisibility, [
            'Không',
            'Khi làm bài xong',
            'Khi tất cả thi xong',
          ], (v) => draft.scoreVisibility = v),
        ),
        _settingRow(
          'Cho xem đề thi và đáp án',
          'Chọn thời điểm hoặc điều kiện công bố đáp án.',
          _choices(draft.answerVisibility, [
            'Không',
            'Khi làm bài xong',
            'Khi tất cả thi xong',
            'Khi đạt điểm nhất định',
          ], (v) => draft.answerVisibility = v),
        ),
        if (draft.answerVisibility == 'Khi đạt điểm nhất định')
          _settingRow(
            'Ngưỡng điểm (%)',
            'Phần trăm điểm tối thiểu để xem đáp án.',
            _choices(
              '${draft.answerThreshold}%',
              ['50%', '60%', '70%', '80%', '90%', '100%'],
              (v) => draft.answerThreshold = int.parse(v.replaceAll('%', '')),
            ),
          ),
        _toggle(
          'Ẩn đáp án cho câu trả lời sai',
          'Mô phỏng chỉ cho biết đúng / sai để học sinh thử lại trước khi xem lời giải.',
          draft.hideWrongAnswers,
          (v) => draft.hideWrongAnswers = v,
        ),
      ]),
      _settingsCard('Cấu hình giá', [_pricing(draft)]),
      _settingsCard('Khác', [
        _toggle(
          'Ẩn thống kê số lượt làm đề',
          'Không hiển thị số lượt làm bài cho học sinh.',
          draft.hideAttemptStats,
          (v) => draft.hideAttemptStats = v,
        ),
        _toggle(
          'Ẩn bảng xếp hạng',
          'Ẩn thứ hạng trong trang kết quả.',
          draft.hideLeaderboard,
          (v) => draft.hideLeaderboard = v,
        ),
        _toggle(
          'Thêm thông tin tiêu đề',
          'Thêm thông tin ở đầu đề khi học sinh vào thi.',
          draft.addHeader,
          (v) => draft.addHeader = v,
        ),
        if (draft.addHeader)
          RecallField(
            'Thông tin tiêu đề',
            controller: _controller('header', draft.header),
            hint: 'Ví dụ: Khoa Công nghệ thông tin',
            onChanged: (v) => draft.header = v,
          ),
        _toggle(
          'Thông báo trước khi vào thi',
          'Học sinh đọc thông báo trước khi bắt đầu.',
          draft.showNotice,
          (v) => draft.showNotice = v,
        ),
        if (draft.showNotice)
          RecallField(
            'Nội dung thông báo',
            controller: _controller('notice', draft.notice),
            lines: 3,
            hint: 'Nhập hướng dẫn làm bài…',
            onChanged: (v) => draft.notice = v,
          ),
      ]),
      Align(
        alignment: Alignment.centerRight,
        child: ActionGroup([
          RecallButton(
            'Hủy',
            outlined: true,
            onPressed: () => go(context, '/teacher/exam-success'),
          ),
          RecallButton(
            'Lưu cài đặt',
            onPressed: () {
              final index = store.examDrafts.indexWhere(
                (e) => e.id == draft.id,
              );
              if (index >= 0) store.examDrafts[index] = draft;
              draft.settingsSaved = true;
              store.activeExam = draft;
              store.assignmentMinutes = draft.minutes;
              store.maxAttempts = draft.attempts;
              store.update();
              go(context, '/teacher/exam-success');
            },
          ),
        ]),
      ),
    ], gap: 24);
  }

  Widget _settingsCard(String title, List<Widget> children) => RecallCard(
    child: VStack([
      SectionTitle(title),
      const Divider(height: 1),
      ...children,
    ], gap: 24),
  );
}
