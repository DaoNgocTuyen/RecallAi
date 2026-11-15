part of '../student_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _StudentPdfViewerPageView on _StudentScreenState {
  Widget _pdf(DemoStore s) {
    final currentPage = page ?? s.viewerPage;
    final text = currentPage == 24
        ? sampleQuestions[5].explanation
        : currentPage == 13
        ? sampleQuestions[1].explanation
        : sampleQuestions[0].explanation;
    return VStack([
      ActionGroup([
        Text(s.source, style: const TextStyle(fontWeight: FontWeight.w600)),
        RecallButton(
          '‹ Trang trước',
          outlined: true,
          onPressed: currentPage <= 1
              ? null
              : () => _refresh(() => page = currentPage - 1),
        ),
        RecallButton(
          'Trang tiếp ›',
          outlined: true,
          onPressed: currentPage >= 24
              ? null
              : () => _refresh(() => page = currentPage + 1),
        ),
        IconButton(
          tooltip: 'Thu nhỏ',
          onPressed: zoom <= 75 ? null : () => _refresh(() => zoom -= 25),
          icon: const Icon(Icons.remove, size: 20),
        ),
        Text('$zoom%'),
        IconButton(
          tooltip: 'Phóng to',
          onPressed: zoom >= 150 ? null : () => _refresh(() => zoom += 25),
          icon: const Icon(Icons.add, size: 20),
        ),
        RecallButton(
          'Tìm trong tài liệu',
          outlined: true,
          onPressed: () => recallDialog(
            context,
            'Tìm trong tài liệu mẫu',
            ListTile(
              title: const Text('JOIN · Trang 24'),
              subtitle: const Text('Kết quả tìm kiếm minh họa'),
              onTap: () {
                Navigator.pop(context);
                _refresh(() => page = 24);
              },
            ),
          ),
        ),
      ]),
      AdaptiveColumns(
        [
          RecallCard(
            color: RecallColors.background,
            child: LayoutBuilder(
              builder: (context, c) => c.maxWidth < 450
                  ? VStack([
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final n in [1, 12, 13, 18, 20, 24])
                            ChoiceChip(
                              label: Text('$n'),
                              selected: currentPage == n,
                              onSelected: (_) => _refresh(() => page = n),
                            ),
                        ],
                      ),
                      _paper(currentPage, text),
                    ])
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 64,
                          child: VStack([
                            for (final n in [1, 12, 13, 18, 20, 24])
                              InkWell(
                                onTap: () => _refresh(() => page = n),
                                child: RecallCard(
                                  padding: 8,
                                  child: VStack([
                                    Muted('Trang $n', small: true),
                                    Container(
                                      height: 50,
                                      color: n == currentPage
                                          ? RecallColors.mint
                                          : RecallColors.background,
                                    ),
                                  ]),
                                ),
                              ),
                          ]),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: _paper(currentPage, text)),
                      ],
                    ),
            ),
          ),
          if (assistantVisible)
            RecallCard(
              child: VStack([
                ActionGroup([
                  for (final t in ['Câu hỏi', 'Flashcard', 'Ghi chú'])
                    TextButton(
                      onPressed: () => _refresh(() => pdfTab = t),
                      child: Text(t),
                    ),
                ]),
                const FigmaImage('imgBiuTngSpark1', screen: 'S08', width: 24),
                const SectionTitle('Hiểu rõ nguồn kiến thức', large: true),
                if (pdfTab == 'Câu hỏi') ...[
                  const Text('INNER JOIN giữ lại những dòng nào?'),
                  RecallButton(
                    'Mở trang 24 và tô sáng',
                    outlined: true,
                    onPressed: () => _refresh(() => page = 24),
                  ),
                  RecallButton(
                    'Luyện tập câu liên quan',
                    secondary: true,
                    onPressed: () => go(context, '/student/generator'),
                  ),
                ] else if (pdfTab == 'Flashcard') ...[
                  const Text('Tự nhớ lại khái niệm trước khi xem lời giải.'),
                  RecallButton(
                    'Mở bộ thẻ ghi nhớ',
                    secondary: true,
                    onPressed: () => go(context, '/student/decks'),
                  ),
                ] else
                  const RecallField(
                    'Ghi chú của bạn',
                    hint: 'Ghi lại kiến thức cần nhớ…',
                    lines: 5,
                  ),
              ]),
            ),
        ],
        flex: assistantVisible
            ? (compactAssistant ? const [8, 3] : const [6, 4])
            : const [1],
      ),
      ActionGroup([
        RecallButton(
          'Thu hẹp trợ lý',
          quiet: true,
          onPressed: () => _refresh(() => compactAssistant = !compactAssistant),
        ),
        RecallButton(
          'Ẩn / Hiện trợ lý',
          outlined: true,
          onPressed: () => _refresh(() => assistantVisible = !assistantVisible),
        ),
        RecallButton(
          '← Về phân tích lỗi',
          quiet: true,
          onPressed: () => go(context, '/student/explanation'),
        ),
      ]),
    ], gap: 24);
  }

  Widget _paper(int currentPage, String passage) => RecallCard(
    child: VStack([
      Muted('Trang $currentPage / 24 · Nội dung PDF minh họa', small: true),
      const SectionTitle('CƠ SỞ DỮ LIỆU', large: true),
      const Muted(
        'NỘI DUNG MINH HỌA · KHÔNG PHẢI TRÍCH DẪN PDF THẬT',
        small: true,
      ),
      RecallCard(
        color: RecallColors.mint,
        padding: 16,
        child: Text(
          passage,
          style: TextStyle(fontSize: 16 * zoom / 100, height: 1.5),
        ),
      ),
      const Muted(
        'Các khóa và mối quan hệ giúp tổ chức dữ liệu nhất quán. Hãy kiểm chứng nội dung học tập với tài liệu gốc.',
      ),
      const Muted(
        'Tài liệu và các số trang trong bản mẫu không phải trích xuất từ tệp thật.',
        small: true,
      ),
    ]),
  );
}
