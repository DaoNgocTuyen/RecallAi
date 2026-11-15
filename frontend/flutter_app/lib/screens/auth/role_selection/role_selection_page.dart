part of '../auth_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _AuthRoleSelectionPageView on _AuthScreenState {
  Widget _roleLayout(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontal = constraints.maxWidth >= 640;
        final cards = <Widget>[
          _roleCard(
            false,
            'Học sinh / Sinh viên',
            'Tự học với AI, luyện tập bằng flashcard và theo dõi tiến độ ghi nhớ.',
            'imgIconCap',
          ),
          _roleCard(
            true,
            'Giáo viên',
            'Quản lý lớp học, tạo câu hỏi, giao bài kiểm tra và theo dõi kết quả.',
            'imgIconTeacher',
          ),
        ];
        return VStack(
          [
            if (horizontal)
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RecallRobot(size: 80, authScreen: 'M04'),
                  SizedBox(width: 16),
                  Text(
                    'RecallAI',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: RecallColors.green,
                    ),
                  ),
                ],
              )
            else
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'RecallAI',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: RecallColors.green,
                    ),
                  ),
                  RecallRobot(size: 96, authScreen: 'M04'),
                ],
              ),
            Text(
              'Bạn là ai\ntrong RecallAI?',
              textAlign: horizontal ? TextAlign.center : TextAlign.start,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const Muted(
              'Chọn vai trò để chúng mình cá nhân hóa trải nghiệm cho bạn.',
            ),

            if (horizontal)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: cards[0]),
                    const SizedBox(width: 24),
                    Expanded(child: cards[1]),
                  ],
                ),
              )
            else
              VStack(cards, gap: 24),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: VStack([
                  RecallButton(
                    'Tiếp tục →',
                    fullWidth: true,
                    onPressed: () {
                      DemoScope.of(context).setRole(teacher);
                      go(
                        context,
                        teacher ? '/teacher/dashboard' : '/student/dashboard',
                      );
                    },
                  ),
                  const Center(
                    child: Muted(
                      'Bạn có thể thay đổi vai trò trong Cài đặt.',
                      small: true,
                    ),
                  ),
                ], gap: 12),
              ),
            ),
          ],
          gap: horizontal ? 20 : 24,
          crossAxisAlignment: horizontal
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
        );
      },
    );
  }
}
