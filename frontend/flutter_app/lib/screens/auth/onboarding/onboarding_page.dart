part of '../auth_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _AuthOnboardingPageView on _AuthScreenState {
  Widget _onboardingPage(BuildContext context) => VStack([
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'RecallAI',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        TextButton(
          onPressed: () => go(context, '/login'),
          child: const Text('Bỏ qua'),
        ),
      ],
    ),
    Pill('0${step + 1}/ KHÁM PHÁ RECALLAI'),
    SizedBox(
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned.fill(
            child: Center(
              child: FigmaImage(
                'imgEllipse',
                screen: 'M02',
                width: 320,
                height: 320,
              ),
            ),
          ),
          const RecallRobot(size: 240, authScreen: 'M02'),
          Positioned(
            left: 12,
            top: 32,
            child: Transform.rotate(
              angle: -.18,
              child: const RecallCard(
                padding: 20,
                child: VStack([
                  FigmaImage('imgIconFile', screen: 'M02', width: 28),
                  Text('PDF', style: TextStyle(fontWeight: FontWeight.w600)),
                ]),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 24,
            child: Transform.rotate(
              angle: .12,
              child: const RecallCard(
                padding: 20,
                child: VStack([
                  FigmaImage('imgIconCheck', screen: 'M02', width: 24),
                  Text(
                    'Flashcard',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    ),
    Text(
      [
        'Biến tài liệu\nthành kiến thức',
        'Tự nhớ lại,\nhiểu kiến thức sâu hơn',
        'Ôn đúng lúc,\nghi nhớ bền vững',
      ][step],
      style: Theme.of(context).textTheme.headlineLarge,
    ),
    Muted(
      [
        'Tải tài liệu PDF hoặc nhập nội dung bài học để AI hỗ trợ tạo câu hỏi và thẻ ghi nhớ.',
        'Luyện tập Active Recall, tự trả lời trước khi xem đáp án và phân tích lỗi sai.',
        'Theo dõi lịch ôn và đánh giá mức ghi nhớ bằng bốn lựa chọn đơn giản.',
      ][step],
    ),
    Row(
      children: List.generate(
        3,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: i == step ? 24 : 16,
          height: 8,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: i == step ? RecallColors.green : RecallColors.border,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    ),
    const SizedBox(height: 16),
    RecallButton(
      step == 2 ? 'Bắt đầu học →' : 'Tiếp tục →',
      fullWidth: true,
      onPressed: () {
        if (step < 2) {
          _refresh(() => step++);
        } else {
          go(context, '/login');
        }
      },
    ),
    const Center(child: Muted('Học ít hơn. Nhớ nhiều hơn.', small: true)),
  ], gap: 24);
}
