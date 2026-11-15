part of '../exam_creation_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _ExamCreationCreateExamPageView on _ExamCreationScreenState {
  void _chooseMethod(DemoStore store, ExamMethod method) {
    if (method == ExamMethod.excel || method == ExamMethod.offlineExcel) {
      _pickFile(store, method: method);
      return;
    }
    store.pendingExam = _newDraft(store, method);
    go(context, '/teacher/exam-config');
  }

  Widget _creationHub(DemoStore store) => VStack([
    const Muted(
      'Chọn tài liệu hoặc một cách tạo đề để bắt đầu bài kiểm tra của bạn.',
    ),
    LayoutBuilder(
      builder: (context, c) {
        final upload = _uploadPanel(store, c.maxWidth >= 900);
        final methods = VStack([
          _methodGroup(
            store,
            'Online',
            ExamMethod.values.where((m) => m.online && m != ExamMethod.upload),
          ),
          _methodGroup(
            store,
            'Offline',
            ExamMethod.values.where((m) => !m.online),
          ),
        ], gap: 24);
        if (c.maxWidth < 900) return VStack([upload, methods], gap: 24);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 6, child: upload),
            const SizedBox(width: 24),
            Expanded(flex: 5, child: methods),
          ],
        );
      },
    ),
    if (store.examDrafts.isNotEmpty)
      RecallCard(
        child: VStack([
          const SectionTitle('Đề đã tạo trong phiên'),
          for (final draft in store.examDrafts.reversed)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.description_outlined,
                color: RecallColors.green,
              ),
              title: Text(draft.title),
              subtitle: Text(
                '${draft.id} · ${draft.subject} · ${draft.method.online ? 'Online' : 'Offline'}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                store.activeExam = draft;
                store.assignmentName = draft.title;
                store.update();
                go(context, '/teacher/exam-success');
              },
            ),
        ]),
      ),
  ], gap: 20);

  Widget _methodGroup(
    DemoStore store,
    String title,
    Iterable<ExamMethod> methods,
  ) => RecallCard(
    padding: 0,
    child: Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: SectionTitle(title),
        tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        children: [
          for (final method in methods)
            Column(
              children: [
                const Divider(height: 1),
                InkWell(
                  onTap: () => _chooseMethod(store, method),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: RecallColors.mint,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            method.icon,
                            color: RecallColors.green,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: VStack([
                            Text(
                              method.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Muted(method.description),
                          ], gap: 8),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.chevron_right,
                          size: 18,
                          color: RecallColors.muted,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    ),
  );
}
