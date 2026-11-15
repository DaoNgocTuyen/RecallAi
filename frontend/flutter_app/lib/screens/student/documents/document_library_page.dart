part of '../student_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _StudentDocumentLibraryPageView on _StudentScreenState {
  Widget _documents(DemoStore s) {
    var docs = s.documents
        .where(
          (d) =>
              d.title.toLowerCase().contains(query.toLowerCase()) &&
              (subject == 'Tất cả' || d.subject == subject) &&
              (status == 'Tất cả' ||
                  (d.ready ? 'Đã xử lý' : 'Đang xử lý') == status),
        )
        .toList();
    if (documentOrder == 'Cũ nhất') docs = docs.reversed.toList();
    Widget docCard(DemoDocument d) => RecallCard(
      child: VStack([
        const FigmaImage('imgBiuTngFile', width: 32),
        SectionTitle(d.title, large: true),
        Muted(d.subject, small: true),
        Pill(d.ready ? 'Đã xử lý' : 'Đang xử lý'),
        Muted(
          '${d.id == 'DOC-CSDL-001'
              ? '11'
              : d.id == 'DOC-CS-001'
              ? '10'
              : '09'}/11/2026 · ${d.pages == null ? 'Chưa xác định số trang' : '${d.pages} trang'}',
          small: true,
        ),
        Muted(
          d.ready
              ? '${d.id == 'DOC-CSDL-001' ? '20' : '15'} bài luyện tập · ${d.id == 'DOC-CSDL-001' ? '48' : '32'} flashcard'
              : 'Chưa có nội dung được tạo',
          small: true,
        ),
        RecallButton(
          'Mở tài liệu',
          secondary: true,
          onPressed: () {
            if (d.id == 'DOC-CSDL-001') {
              s.chooseSource(d);
              go(context, '/student/pdf');
            } else {
              feedback(
                context,
                'Tài liệu này chưa có nội dung xem trước trong bộ giao diện mẫu.',
              );
            }
          },
        ),
        ActionGroup([
          RecallButton(
            'Luyện tập',
            outlined: true,
            onPressed: () {
              if (d.id == 'DOC-CSDL-001') {
                s.chooseSource(d);
                go(context, '/student/studio');
              } else {
                feedback(
                  context,
                  'Luồng trình diễn sử dụng Cơ sở dữ liệu.pdf.',
                );
              }
            },
          ),
          PopupMenuButton<String>(
            tooltip: 'Quản lý tài liệu',
            onSelected: (v) => _documentAction(s, d, v),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'flash', child: Text('Tạo Flashcard')),
              PopupMenuItem(value: 'rename', child: Text('Đổi tên')),
              PopupMenuItem(value: 'delete', child: Text('Xóa tài liệu')),
            ],
            child: const Padding(padding: EdgeInsets.all(12), child: Text('⋯')),
          ),
        ]),
      ]),
    );
    return VStack([
      const Muted('Quản lý học liệu và bắt đầu học tập cùng AI.'),
      AdaptiveColumns([
        RecallField(
          'Tìm tài liệu',
          hint: 'Nhập tên tài liệu…',
          onChanged: (v) => _refresh(() => query = v),
        ),
        ActionGroup([
          RecallButton(
            'Thêm tài liệu',
            onPressed: () => go(context, '/student/upload'),
          ),
          RecallButton(
            'Dạng thẻ',
            secondary: !listView,
            outlined: listView,
            onPressed: () => _refresh(() => listView = false),
          ),
          RecallButton(
            'Danh sách',
            secondary: listView,
            outlined: !listView,
            onPressed: () => _refresh(() => listView = true),
          ),
        ]),
      ]),
      ActionGroup([
        _dropdown(
          subject,
          ['Tất cả', 'Cơ sở dữ liệu', 'Lập trình C#', 'Nhập môn AI'],
          (v) => _refresh(() => subject = v),
          label: 'Môn học',
        ),
        _dropdown(
          documentOrder,
          ['Mới nhất', 'Cũ nhất'],
          (v) => _refresh(() => documentOrder = v),
          label: 'Ngày tải lên',
        ),
        _dropdown(
          status,
          ['Tất cả', 'Đã xử lý', 'Đang xử lý'],
          (v) => _refresh(() => status = v),
          label: 'Trạng thái',
        ),
      ]),
      Muted('${docs.length} tài liệu', small: true),
      if (docs.isEmpty)
        EmptyPanel(
          'Chưa có tài liệu phù hợp',
          'Đổi bộ lọc hoặc thêm học liệu mới.',
          action: RecallButton(
            'Thêm tài liệu',
            secondary: true,
            onPressed: () => go(context, '/student/upload'),
          ),
        )
      else if (listView)
        VStack(
          docs
              .map(
                (d) => RecallCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const FigmaImage('imgBiuTngFile', width: 28),
                    title: Text(d.title),
                    subtitle: Text(
                      '${d.subject} · ${d.ready ? 'Đã xử lý' : 'Đang xử lý'}',
                    ),
                    trailing: RecallButton(
                      'Mở',
                      secondary: true,
                      onPressed: () {
                        s.chooseSource(d);
                        go(context, '/student/pdf');
                      },
                    ),
                  ),
                ),
              )
              .toList(),
        )
      else
        AdaptiveGrid(docs.map(docCard).toList()),
    ], gap: 24);
  }

  Future<void> _documentAction(
    DemoStore s,
    DemoDocument d,
    String action,
  ) async {
    if (action == 'flash') {
      go(context, '/student/decks');
      return;
    }
    var value = d.title;
    if (action == 'rename') {
      await recallDialog(
        context,
        'Đổi tên tài liệu',
        RecallField(
          'Tên tài liệu',
          initial: value,
          onChanged: (v) => value = v,
        ),
        actions: [
          RecallButton(
            'Lưu tên',
            onPressed: () {
              if (value.trim().isEmpty) return;
              if (s.source == d.title) s.source = value.trim();
              d.title = value.trim();
              s.update();
              Navigator.pop(context);
            },
          ),
        ],
      );
    } else {
      await recallDialog(
        context,
        'Xóa tài liệu?',
        Text(
          'Ẩn “${d.title}” khỏi thư viện giao diện mẫu. Lịch sử học vẫn được giữ.',
        ),
        actions: [
          RecallButton(
            'Xóa tài liệu',
            danger: true,
            onPressed: () {
              s.documents.remove(d);
              s.update();
              Navigator.pop(context);
            },
          ),
          RecallButton(
            'Hủy',
            quiet: true,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    }
  }
}
