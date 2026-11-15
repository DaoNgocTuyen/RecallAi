part of '../auth_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _AuthLoginPageView on _AuthScreenState {
  Widget _loginPage(BuildContext context) => _credentialsForm(context, false);
}
