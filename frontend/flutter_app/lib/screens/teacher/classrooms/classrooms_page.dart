part of '../teacher_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _TeacherClassroomsPageView on _TeacherScreenState {
  Widget _classes(DemoStore s) => VStack([
    ActionGroup([
      RecallButton('+ Tạo lớp học', onPressed: () => _createClass(s)),
      RecallButton(
        'Đang hoạt động',
        secondary: filter == 'Tất cả',
        outlined: filter != 'Tất cả',
        onPressed: () => _refresh(() => filter = 'Tất cả'),
      ),
      RecallButton(
        'Đã lưu trữ',
        outlined: true,
        onPressed: () => _refresh(() => filter = 'Lưu trữ'),
      ),
    ]),
    RecallField(
      'Tìm lớp học',
      hint: 'Tìm theo tên hoặc mã lớp…',
      onChanged: (v) => _refresh(() => query = v),
    ),
    if (filter == 'Lưu trữ')
      const EmptyPanel(
        'Chưa có lớp được lưu trữ',
        'Lớp được lưu trữ sẽ xuất hiện tại đây.',
      )
    else
      _classTable(s),
  ], gap: 24);

  Widget _classTable(DemoStore s) => RecallTable(
    headers: const [
      'Lớp học',
      'Mã lớp',
      'Thành viên',
      'Bài kiểm tra',
      'Hoạt động gần nhất',
      'Trạng thái',
      '',
    ],
    rows: [
      for (final c in s.classes.where(
        (c) =>
            '${c.name} ${c.code}'.toLowerCase().contains(query.toLowerCase()),
      ))
        [
          Text(c.name),
          Text(c.code, style: const TextStyle(color: RecallColors.green)),
          Text('${c.members}'),
          Text(c.code == 'CSDL-K23' ? '4' : '3'),
          const Text('Vừa cập nhật nội dung học'),
          const Pill('Đang hoạt động'),
          TextButton(
            onPressed: () {
              s.selectedClass = s.classes.indexOf(c);
              s.update();
              go(context, '/teacher/classroom');
            },
            child: const Text('Mở →'),
          ),
        ],
    ],
  );

  Future<void> _createClass(DemoStore s) async {
    var name = 'Ôn thi CSDL – Nhóm 02';
    await recallDialog(
      context,
      'Tạo lớp học',
      VStack([
        RecallField('Tên lớp', initial: name, onChanged: (v) => name = v),
        const RecallField('Môn học', initial: 'Cơ sở dữ liệu'),
        const RecallField(
          'Mô tả lớp',
          hint: 'Nội dung học tập của lớp…',
          lines: 3,
        ),
      ]),
      actions: [
        RecallButton(
          'Tạo lớp',
          onPressed: () {
            if (name.trim().isEmpty) return;
            s.createClass(name.trim());
            Navigator.pop(context);
            final c = s.classes.last;
            recallDialog(
              context,
              'Tạo lớp thành công',
              VStack([
                SectionTitle(c.name),
                Text(
                  c.code,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: RecallColors.green,
                  ),
                ),
                const Text(
                  '0 thành viên · Mã mời dùng trong phiên giao diện mẫu.',
                ),
              ]),
              actions: [
                RecallButton(
                  'Sao chép mã',
                  secondary: true,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: c.code));
                    feedback(context, 'Đã sao chép mã lớp.');
                  },
                ),
                RecallButton(
                  'Xem lớp',
                  onPressed: () {
                    s.selectedClass = s.classes.length - 1;
                    s.update();
                    Navigator.pop(context);
                    go(context, '/teacher/classroom');
                  },
                ),
              ],
            );
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
