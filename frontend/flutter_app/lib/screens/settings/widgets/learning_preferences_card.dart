import 'package:flutter/material.dart';
import 'package:recallai_frontend/models/demo_store.dart';
import 'package:recallai_frontend/widgets/recall_widgets.dart';

class LearningPreferencesCard extends StatelessWidget {
  const LearningPreferencesCard({super.key});
  @override
  Widget build(BuildContext context) {
    final s = DemoScope.of(context);
    return RecallCard(
      child: VStack([
        const SectionTitle('Tùy chọn học tập'),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Nhắc lịch ôn tập'),
          subtitle: const Text('09:00 mỗi ngày · Chỉ là giao diện mẫu'),
          value: s.reminder,
          onChanged: (v) {
            s.reminder = v;
            s.update();
          },
        ),
        const Text('Ngôn ngữ: Tiếng Việt'),
        const Text('Giao diện: Sáng'),
      ]),
    );
  }
}
