import 'package:flutter/material.dart';
import 'package:recallai_frontend/design/recall_theme.dart';
import 'package:recallai_frontend/models/demo_store.dart';
import 'package:recallai_frontend/widgets/recall_widgets.dart';

part 'splash/splash_page.dart';
part 'onboarding/onboarding_page.dart';
part 'login/login_page.dart';
part 'register/register_page.dart';
part 'role_selection/role_selection_page.dart';
part 'role_selection/widgets/role_card.dart';
part 'widgets/credentials_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.path});
  final String path;
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final formKey = GlobalKey<FormState>();
  bool hidden = true, teacher = false;
  int step = 0;
  @override
  Widget build(BuildContext context) {
    final isSplash = widget.path == '/splash',
        isOnboard = widget.path == '/onboarding',
        isRole = widget.path == '/role',
        isRegister = widget.path == '/register';
    final width = MediaQuery.sizeOf(context).width;
    final responsiveAuth = isRole || widget.path == '/login';
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              RecallColors.mint,
              RecallColors.background,
              RecallColors.cyan,
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: responsiveAuth
                  ? (isRole ? 920 : 1120)
                  : (width < 600 ? double.infinity : 460),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: responsiveAuth ? (width * .035).clamp(24, 48) : 24,
                vertical: responsiveAuth ? 24 : 32,
              ),
              child: Form(
                key: formKey,
                child: VStack([
                  if (isSplash) ...[
                    _splashPage(context),
                  ] else if (isOnboard) ...[
                    _onboardingPage(context),
                  ] else if (isRole) ...[
                    _roleLayout(context),
                  ] else ...[
                    isRegister ? _registerPage(context) : _loginPage(context),
                  ],
                ], gap: 24),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _refresh(VoidCallback update) => setState(update);
}
