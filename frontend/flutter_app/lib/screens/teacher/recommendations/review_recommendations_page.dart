part of '../teacher_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _TeacherReviewRecommendationsPageView on _TeacherScreenState {
  Widget _recommendations(DemoStore s) => VStack([
    const Muted(
      'Đề xuất hỗ trợ quyết định, không phải kết luận chắc chắn. Giáo viên xem lại trước khi giao.',
    ),
    for (final (topic, className, proof, note) in [
      (
        'SQL JOIN',
        'Cơ sở dữ liệu – K24',
        '29 / 50 lượt trả lời chưa chính xác (58%).',
        'Ôn INNER JOIN, LEFT JOIN và điều kiện ON.',
      ),
      (
        'Entity Framework Core',
        'Lập trình C# – Nhóm 01',
        '12 / 30 sinh viên có độ chính xác dưới 60% ở nhóm câu EF Core.',
        'Ôn DbContext, theo dõi thay đổi và SaveChanges.',
      ),
    ])
      RecallCard(
        child: VStack([
          SectionTitle(topic, large: true),
          Muted(className),
          const Pill('Ưu tiên cao'),
          Text(proof),
          const Muted('Nguồn: kết quả bài kiểm tra trong lớp được phân quyền.'),
          Text(note),
          Text(
            s.reviewAssigned
                ? 'Đã giao hoạt động'
                : s.reviewApproved
                ? 'Đã duyệt đề xuất'
                : 'Đề xuất chưa duyệt',
            style: const TextStyle(color: RecallColors.green),
          ),
          ActionGroup([
            RecallButton(
              'Xem câu hỏi sai',
              outlined: true,
              onPressed: () => recallDialog(
                context,
                'Bằng chứng từ bài làm',
                Text('$proof\n$note'),
              ),
            ),
            RecallButton(
              'Tạo bài luyện tập',
              secondary: true,
              onPressed: () => go(context, '/teacher/generate'),
            ),
            RecallButton(
              'Tạo flashcard',
              outlined: true,
              onPressed: () => _reviewApproval(s, note),
            ),
            RecallButton(
              'Giao bài ôn tập',
              onPressed: () {
                if (!s.reviewApproved) {
                  _reviewApproval(s, note);
                } else {
                  s.reviewAssigned = true;
                  s.update();
                  feedback(context, 'Đã giao hoạt động ôn tập trong lớp mẫu.');
                }
              },
            ),
            RecallButton(
              'Xem lại và duyệt',
              quiet: true,
              onPressed: () => _reviewApproval(s, note),
            ),
          ]),
        ]),
      ),
  ], gap: 24);

  void _reviewApproval(DemoStore s, String note) => recallDialog(
    context,
    'Xem lại đề xuất trước khi giao',
    VStack([
      RecallField('Nội dung cần ưu tiên', initial: note, lines: 3),
      const Muted(
        'Duyệt đề xuất không thay thế việc duyệt câu hỏi trước khi xuất bản.',
      ),
      const ActionGroup([
        Pill('Bài luyện tập 5 câu'),
        Pill('Bộ flashcard ôn tập'),
      ]),
    ]),
    actions: [
      RecallButton(
        'Duyệt đề xuất',
        onPressed: () {
          s.reviewApproved = true;
          s.update();
          Navigator.pop(context);
          feedback(context, 'Đã duyệt đề xuất. Bạn có thể giao hoạt động.');
        },
      ),
    ],
  );
}
