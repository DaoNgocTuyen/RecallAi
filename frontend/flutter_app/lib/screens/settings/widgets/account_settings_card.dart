import 'package:flutter/material.dart';
import 'package:recallai_frontend/models/demo_store.dart';
import 'package:recallai_frontend/widgets/recall_widgets.dart';

class AccountSettingsCard extends StatelessWidget {
  const AccountSettingsCard({super.key});
  @override
  Widget build(BuildContext context) {
    final s = DemoScope.of(context);
    return RecallCard(
      child: VStack([
        const SectionTitle('Thông tin tài khoản'),
        RecallField('Họ và tên', initial: s.name, onChanged: (v) => s.name = v),
        const RecallField('Email', initial: 'minh.anh@recallai.vn'),
        RecallButton(
          'Lưu thay đổi',
          onPressed: () {
            s.update();
            feedback(context, 'Đã cập nhật thông tin giao diện mẫu.');
          },
        ),
      ]),
    );
  }
}
