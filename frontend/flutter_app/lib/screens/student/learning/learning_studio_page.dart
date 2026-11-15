part of '../student_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _StudentLearningStudioPageView on _StudentScreenState {
  Widget _studio(DemoStore s) => VStack([
    const Muted('Biến tài liệu thành bài luyện tập và thẻ ghi nhớ.'),
    const ActionGroup([
      Pill('1. Chọn tài liệu'),
      Pill('2. Chọn hình thức học'),
      Pill('3. Thiết lập nội dung'),
      Pill('4. Tạo bằng AI'),
    ]),
    AdaptiveColumns([
      RecallCard(
        child: VStack([
          const SectionTitle('Chọn nguồn nội dung', large: true),
          ActionGroup([
            RecallButton(
              'Tải PDF',
              secondary: !textMode,
              outlined: textMode,
              onPressed: () => _refresh(() {
                textMode = false;
                s.sourceIsPdf = true;
              }),
            ),
            RecallButton(
              'Nhập văn bản',
              secondary: textMode,
              outlined: !textMode,
              onPressed: () => _refresh(() {
                textMode = true;
                s.sourceIsPdf = false;
              }),
            ),
          ]),
          if (textMode)
            RecallField(
              'Nội dung bài học',
              initial: s.textSource,
              hint: 'Dán nội dung bài học tại đây…',
              lines: 6,
              onChanged: (v) => s.textSource = v,
            )
          else
            RecallCard(
              color: RecallColors.background,
              child: VStack([
                const FigmaImage('imgBiuTngUpload', screen: 'S03', width: 40),
                const SectionTitle('Tải tệp PDF của bạn', large: true),
                const Muted(
                  'PDF tối đa 20 MB · Tệp và tiến trình tải được mô phỏng.',
                ),
                RecallButton(
                  'Chọn PDF mẫu',
                  outlined: true,
                  onPressed: busy ? null : () => _selectPdf(s),
                ),
              ]),
            ),
          if (!textMode && s.fileSelected)
            RecallCard(
              color: RecallColors.mint,
              child: VStack([
                Text(
                  s.source,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Muted('DOC-CSDL-001 · 2,4 MB · 24 trang', small: true),
                Pill(busy ? 'Đang xử lý…' : 'Sẵn sàng tạo nội dung'),
                RecallButton(
                  'Xóa tệp đã chọn',
                  quiet: true,
                  onPressed: () {
                    s.fileSelected = false;
                    s.update();
                  },
                ),
              ]),
            ),
          if (busy)
            const LinearProgressIndicator(color: RecallColors.primaryDark),
          RecallButton(
            'Chọn tài liệu trong thư viện',
            quiet: true,
            onPressed: () => go(context, '/student/documents'),
          ),
        ]),
      ),
      RecallCard(
        child: VStack([
          const SectionTitle('Bạn muốn học theo cách nào?', large: true),
          RecallButton(
            'Bài luyện tập AI',
            secondary: true,
            onPressed: () => go(context, '/student/generator'),
          ),
          RecallButton(
            'Flashcard',
            outlined: true,
            onPressed: () => go(context, '/student/decks'),
          ),
          const Muted(
            'Xem trước cấu hình câu hỏi và nội dung mẫu trước khi bắt đầu.',
          ),
          RecallButton(
            'Bắt đầu tạo',
            onPressed: busy
                ? null
                : () {
                    if (textMode && s.textSource.trim().isEmpty ||
                        !textMode && !s.fileSelected) {
                      feedback(
                        context,
                        'Chọn PDF hoặc nhập nội dung bài học trước.',
                      );
                      return;
                    }
                    if (textMode) s.source = 'Văn bản đã nhập · CSDL';
                    go(context, '/student/generator');
                  },
          ),
          const SectionTitle('Đã tạo gần đây'),
          const Muted(
            'Cơ sở dữ liệu · 20 câu hỏi\nThuật ngữ CSDL · 48 flashcard',
            small: true,
          ),
        ]),
      ),
    ]),
    const Muted(
      'Dữ liệu minh họa · Không kết nối AI, PDF hay cơ sở dữ liệu thật.',
      small: true,
    ),
  ], gap: 24);

  Future<void> _selectPdf(DemoStore s) async {
    final result = await recallDialog<bool>(
      context,
      'Chọn tệp minh họa',
      const VStack([
        Text('Cơ sở dữ liệu.pdf · 2,4 MB · 24 trang'),
        Muted('Bản frontend dùng tệp mẫu, chưa xử lý PDF thật.'),
      ]),
      actions: [
        RecallButton(
          'Chọn tệp này',
          onPressed: () => Navigator.pop(context, true),
        ),
        RecallButton(
          'Thử tệp lỗi · 28 MB',
          outlined: true,
          onPressed: () => Navigator.pop(context, false),
        ),
      ],
    );
    if (!mounted || result == null) return;
    if (!result) {
      feedback(context, 'Không thể tải tệp: tệp mẫu vượt giới hạn 20 MB.');
      return;
    }
    _refresh(() => busy = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    s.source = 'Cơ sở dữ liệu.pdf';
    s.sourceIsPdf = true;
    s.fileSelected = true;
    if (!s.documents.any((d) => d.id == 'DOC-CSDL-001')) {
      s.documents.insert(
        0,
        DemoDocument('DOC-CSDL-001', s.source, 'Cơ sở dữ liệu', 24),
      );
    }
    s.update();
    _refresh(() => busy = false);
    feedback(context, 'Đã tải và phân tích tài liệu mẫu.');
  }
}
