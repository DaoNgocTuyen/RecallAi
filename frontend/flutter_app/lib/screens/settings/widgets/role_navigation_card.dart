import 'package:flutter/material.dart';
import 'package:recallai_frontend/models/demo_store.dart';
import 'package:recallai_frontend/widgets/recall_widgets.dart';

class RoleNavigationCard extends StatelessWidget {
  const RoleNavigationCard({super.key});
  @override
  Widget build(BuildContext context) {
    final s = DemoScope.of(context);
    return RecallCard(
      child: VStack([
        const SectionTitle('Vai trò và điều hướng'),
        ActionGroup([
          RecallButton(
            'Giao diện sinh viên',
            secondary: true,
            onPressed: () {
              s.setRole(false);
              go(context, '/student/dashboard');
            },
          ),
          RecallButton(
            'Giao diện giáo viên',
            outlined: true,
            onPressed: () {
              s.setRole(true);
              go(context, '/teacher/dashboard');
            },
          ),
          RecallButton(
            'Xem giới thiệu',
            quiet: true,
            onPressed: () => go(context, '/onboarding'),
          ),
          RecallButton(
            'Đăng xuất',
            quiet: true,
            onPressed: () => go(context, '/login'),
          ),
        ]),
      ]),
    );
  }
}
