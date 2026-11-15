import 'package:flutter/material.dart';
import 'package:recallai_frontend/models/demo_store.dart';
import 'package:recallai_frontend/widgets/recall_widgets.dart';
import 'widgets/account_settings_card.dart';
import 'widgets/learning_preferences_card.dart';
import 'widgets/role_navigation_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = DemoScope.of(context);
    return AppShell(
      title: 'Cài đặt',
      teacher: s.teacher,
      active: s.teacher ? 7 : 8,
      child: VStack([
        const AccountSettingsCard(),
        const LearningPreferencesCard(),
        const RoleNavigationCard(),
        const Muted(
          'Bản chuyển giao giao diện Figma. Các dữ liệu và thao tác hiện chạy cục bộ, chưa kết nối API.',
        ),
      ]),
    );
  }
}
