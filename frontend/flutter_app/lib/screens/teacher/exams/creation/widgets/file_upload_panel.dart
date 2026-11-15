part of '../exam_creation_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _ExamCreationFileUploadPanelView on _ExamCreationScreenState {
  Future<void> _pickFile(
    DemoStore store, {
    ExamMethod method = ExamMethod.upload,
  }) async {
    if (choosing) return;
    _refresh(() {
      choosing = true;
      fileError = null;
    });
    try {
      final excel =
          method == ExamMethod.excel || method == ExamMethod.offlineExcel;
      final file = await openFile(
        acceptedTypeGroups: [
          XTypeGroup(
            label: excel ? 'Excel' : 'Tài liệu đề thi',
            extensions: excel ? ['xlsx'] : ExamDraft.extensions,
          ),
        ],
      );
      if (file != null && mounted) await _acceptFile(store, file, method);
    } catch (_) {
      if (mounted) {
        _refresh(
          () => fileError =
              'Không mở được tệp. Vui lòng chọn lại hoặc thử tệp khác.',
        );
      }
    } finally {
      if (mounted) _refresh(() => choosing = false);
    }
  }

  Future<void> _acceptFile(
    DemoStore store,
    XFile file,
    ExamMethod method,
  ) async {
    final excel =
        method == ExamMethod.excel || method == ExamMethod.offlineExcel;
    if (!ExamDraft.accepts(file.name) ||
        excel && !file.name.toLowerCase().endsWith('.xlsx')) {
      _refresh(
        () => fileError = excel
            ? 'Vui lòng chọn tệp .xlsx.'
            : 'Định dạng chưa hỗ trợ. Chọn PDF, DOCX, XLSX, TEX, ZIP hoặc ảnh.',
      );
      return;
    }
    try {
      if (await file.length() > 50 * 1024 * 1024) {
        if (mounted) {
          _refresh(
            () => fileError = 'Tệp vượt quá 50 MB. Vui lòng chọn tệp nhỏ hơn.',
          );
        }
        return;
      }
      if (!mounted) return;
      store.pendingExam = _newDraft(store, method)..sourceName = file.name;
      go(context, '/teacher/exam-config');
    } catch (_) {
      if (mounted) {
        _refresh(() => fileError = 'Không đọc được tệp. Vui lòng chọn lại.');
      }
    }
  }

  Widget _uploadPanel(DemoStore store, bool wide) => DropTarget(
    onDragEntered: (_) => _refresh(() => dragging = true),
    onDragExited: (_) => _refresh(() => dragging = false),
    onDragDone: (detail) async {
      _refresh(() => dragging = false);
      if (detail.files.length != 1) {
        _refresh(() => fileError = 'Mỗi lần chọn một tệp đề thi.');
        return;
      }
      await _acceptFile(store, detail.files.first, ExamMethod.upload);
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: dragging ? RecallColors.primary : RecallColors.border,
        borderRadius: BorderRadius.circular(23),
      ),
      child: RecallCard(
        padding: wide ? 32 : 24,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: wide ? 540 : 340),
          child: Center(
            child: VStack([
              const Center(
                child: Icon(
                  Icons.cloud_upload_outlined,
                  size: 64,
                  color: RecallColors.green,
                ),
              ),
              const Center(
                child: SectionTitle(
                  'Chọn tệp hoặc kéo thả tệp vào đây',
                  large: true,
                ),
              ),
              const Center(
                child: Muted(
                  'PDF, DOCX, XLSX, TEX, ZIP, JPG, PNG · Tối đa 50 MB',
                ),
              ),
              Center(
                child: RecallButton(
                  choosing ? 'Đang mở…' : 'Chọn tệp từ thiết bị',
                  onPressed: choosing ? null : () => _pickFile(store),
                ),
              ),
              if (fileError != null)
                Text(
                  fileError!,
                  style: const TextStyle(color: RecallColors.error),
                ),
              const Text(
                'Đính kèm tài liệu để chuẩn bị đề. Sau khi lưu, bạn có thể tự soạn hoặc chọn câu hỏi từ ngân hàng RecallAI.',
                textAlign: TextAlign.center,
                style: TextStyle(color: RecallColors.muted, height: 1.6),
              ),
              Center(
                child: TextButton.icon(
                  onPressed: () => _showTemplates(),
                  icon: const Icon(Icons.description_outlined, size: 18),
                  label: const Text('Xem mẫu định dạng câu hỏi'),
                ),
              ),
              RecallCard(
                color: RecallColors.background,
                padding: 16,
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: RecallColors.green),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Muted(
                        'Tệp chưa được nhập nội dung tự động. Đề được lưu tạm trong phiên mô phỏng.',
                        small: true,
                      ),
                    ),
                  ],
                ),
              ),
            ], gap: 20),
          ),
        ),
      ),
    ),
  );

  void _showTemplates() => recallDialog(
    context,
    'Mẫu định dạng câu hỏi',
    const VStack([
      Text(
        'Trắc nghiệm: câu hỏi, lựa chọn A–D, đáp án đúng, giải thích và chủ đề.',
      ),
      Text('Đúng / Sai: mệnh đề, đáp án và giải thích.'),
      Text('Tự luận: câu hỏi, đáp án tham khảo và thang điểm.'),
      SelectableText('Câu hỏi | A | B | C | D | Đáp án | Giải thích | Chủ đề'),
      Muted(
        'Đây là hướng dẫn cấu trúc dữ liệu. Bản frontend chưa đọc hoặc chuyển đổi nội dung tệp.',
      ),
    ]),
  );
}
