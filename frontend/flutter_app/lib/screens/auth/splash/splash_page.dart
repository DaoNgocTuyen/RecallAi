part of '../auth_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _AuthSplashPageView on _AuthScreenState {
  Widget _splashPage(BuildContext context) => VStack([
    const SizedBox(height: 60),
    const Center(child: RecallRobot(size: 220, authScreen: 'M01')),
    Center(
      child: Text(
        'RecallAI',
        style: Theme.of(
          context,
        ).textTheme.headlineLarge!.copyWith(fontSize: 44),
      ),
    ),
    const Center(
      child: Text('Học chủ động, nhớ lâu hơn', textAlign: TextAlign.center),
    ),
    const SizedBox(height: 100),
    RecallButton(
      'Bắt đầu khám phá →',
      fullWidth: true,
      onPressed: () => go(context, '/onboarding'),
    ),
  ], gap: 24);
}
