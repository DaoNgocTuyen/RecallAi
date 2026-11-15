part of '../student_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _StudentStudyPlannerPageView on _StudentScreenState {
  Widget _planner(DemoStore s) => VStack([
    const Muted('Đề xuất có thể chỉnh sửa · Bộ dữ liệu lịch mẫu 12/11/2026.'),
    AdaptiveColumns([
      RecallCard(
        child: VStack([
          RecallField(
            'Tên kỳ thi',
            initial: s.examName,
            onChanged: (v) => s.examName = v,
          ),
          RecallField(
            'Môn học',
            initial: s.examSubject,
            onChanged: (v) => s.examSubject = v,
          ),
          RecallField(
            'Ngày thi',
            key: ValueKey(s.examDate),
            initial: dateLabel(s.examDate),
            readOnly: true,
            onTap: () async {
              final d = await showDatePicker(
                context: context,
                initialDate: s.examDate,
                firstDate: DateTime(2026, 11),
                lastDate: DateTime(2030, 12, 31),
              );
              if (d != null) {
                s.examDate = d;
                s.update();
              }
            },
          ),
          RecallField(
            'Mục tiêu',
            initial: s.goal,
            lines: 2,
            onChanged: (v) => s.goal = v,
          ),
          const Text(
            'Thời gian học mỗi ngày',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          ActionGroup([
            for (final n in [30, 60, 120])
              ChoiceChip(
                label: Text('$n phút'),
                selected: s.dailyMinutes == n,
                onSelected: (_) {
                  s.dailyMinutes = n;
                  s.update();
                },
              ),
          ]),
          const Text(
            'Những ngày có thể học',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          ActionGroup([
            for (var i = 1; i <= 7; i++)
              FilterChip(
                label: Text(i == 7 ? 'CN' : 'T${i + 1}'),
                selected: s.studyDays.contains(i),
                onSelected: (v) {
                  v ? s.studyDays.add(i) : s.studyDays.remove(i);
                  s.update();
                },
              ),
          ]),
          const Text('Nội dung cần ưu tiên'),
          const ActionGroup([
            Pill('SQL JOIN'),
            Pill('Khóa và ràng buộc'),
            Pill('Truy vấn SQL'),
          ]),
          RecallButton(
            'Tạo kế hoạch với AI',
            onPressed: () {
              if (s.studyDays.isEmpty) {
                feedback(context, 'Chọn ít nhất một ngày học trong tuần.');
                return;
              }
              s.generatePlan();
              feedback(context, 'Đã tạo gợi ý lịch học mẫu.');
            },
          ),
        ]),
      ),
      RecallCard(
        color: RecallColors.mint,
        child: VStack([
          const FigmaImage('imgBiuTngSpark1', screen: 'S08', width: 24),
          const SectionTitle('Kế hoạch được đề xuất', large: true),
          Text(
            '${s.examDate.difference(DateTime(2026, 11, 12)).inDays} ngày',
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(color: RecallColors.green),
          ),
          Text(
            s.planGenerated ? '${s.tasks.length} buổi học' : '23 buổi học',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text('${s.dailyMinutes} phút/ngày'),
          const Muted(
            'Ôn nền tảng → Luyện tập → Tự kiểm tra → Bổ sung ngày đệm.',
          ),
          const SectionTitle('SQL JOIN'),
          const Muted(
            'AI chỉ đưa ra gợi ý dựa trên ngày thi, thời gian và tiến độ mẫu.',
            small: true,
          ),
          RecallButton(
            'Lưu kế hoạch',
            onPressed: () {
              if (s.studyDays.isEmpty) {
                feedback(context, 'Kế hoạch cần ít nhất một ngày học.');
                return;
              }
              if (!s.planGenerated) s.generatePlan();
              feedback(context, 'Đã lưu kế hoạch trong phiên giao diện mẫu.');
            },
          ),
          RecallButton(
            'Tạo lại gợi ý',
            outlined: true,
            onPressed: () {
              if (s.studyDays.isNotEmpty) s.generatePlan();
            },
          ),
        ]),
      ),
    ]),
    RecallCard(
      child: VStack([
        const SectionTitle('Kế hoạch học tập trong ngày', large: true),
        Muted(
          '${s.tasks.where((t) => t.done).length} / ${s.tasks.length} nhiệm vụ hoàn thành',
        ),
        for (final t in s.tasks.take(12))
          RecallCard(
            padding: 16,
            child: VStack([
              Text(
                t.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Muted('${timeLabel(t.date)} · ${t.minutes} phút'),
              Pill(t.done ? 'Đã hoàn thành' : 'Chưa bắt đầu'),
              ActionGroup([
                RecallButton(
                  'Chi tiết / Dời lịch',
                  outlined: true,
                  onPressed: () => _taskEditor(s, t),
                ),
                RecallButton(
                  t.done ? 'Đã hoàn thành ✓' : 'Đánh dấu hoàn thành',
                  secondary: true,
                  onPressed: t.done
                      ? null
                      : () {
                          t.done = true;
                          s.update();
                        },
                ),
              ]),
            ]),
          ),
      ]),
    ),
  ], gap: 24);

  Future<void> _taskEditor(DemoStore s, StudyTask t) async {
    var title = t.title, minutes = t.minutes.toString();
    await recallDialog(
      context,
      'Nhiệm vụ học tập',
      VStack([
        RecallField('Nội dung', initial: title, onChanged: (v) => title = v),
        RecallField(
          'Thời lượng (phút)',
          initial: minutes,
          onChanged: (v) => minutes = v,
        ),
        Text(timeLabel(t.date)),
        RecallButton(
          'Dời lịch học',
          outlined: true,
          onPressed: () async {
            final d = await showDatePicker(
              context: context,
              initialDate: t.date,
              firstDate: DateTime(2026, 11),
              lastDate: s.examDate,
            );
            if (d != null) {
              t.date = DateTime(d.year, d.month, d.day, t.date.hour);
              s.update();
              if (mounted) {
                feedback(context, 'Đã dời lịch sang ${dateLabel(t.date)}.');
              }
            }
          },
        ),
      ]),
      actions: [
        RecallButton(
          'Lưu thay đổi',
          onPressed: () {
            final n = int.tryParse(minutes);
            if (title.trim().isEmpty || n == null || n < 1) {
              feedback(context, 'Nhập nội dung và thời lượng hợp lệ.');
              return;
            }
            t.title = title;
            t.minutes = n;
            s.update();
            Navigator.pop(context);
          },
        ),
        RecallButton(
          'Bắt đầu ngay',
          secondary: true,
          onPressed: () {
            Navigator.pop(context);
            go(
              context,
              t.title.contains('flashcard')
                  ? '/student/review'
                  : '/student/generator',
            );
          },
        ),
      ],
    );
  }
}
