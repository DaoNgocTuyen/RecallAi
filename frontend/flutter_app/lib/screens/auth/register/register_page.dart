part of '../auth_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _AuthRegisterPageView on _AuthScreenState {
  Widget _registerPage(BuildContext context) => _credentialsForm(context, true);
}
