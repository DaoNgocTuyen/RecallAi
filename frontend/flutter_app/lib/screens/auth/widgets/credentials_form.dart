part of '../auth_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _AuthCredentialsFormView on _AuthScreenState {
  Widget _credentialsForm(BuildContext context, bool isRegister) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 860 && !isRegister;
        final gap = desktop ? 14.0 : 24.0;
        final branding = VStack(
          [
            Center(
              child: RecallRobot(size: desktop ? 200 : 110, authScreen: 'M03'),
            ),
            const Center(
              child: Text(
                'RecallAI',
                style: TextStyle(
                  fontSize: 18,
                  color: RecallColors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              isRegister ? 'Bắt đầu hành trình học tập' : 'Chào mừng trở lại!',
              textAlign: desktop ? TextAlign.center : TextAlign.start,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Muted(
              isRegister
                  ? 'Tạo giao diện tài khoản học tập của bạn.'
                  : 'Đăng nhập để tiếp tục hành trình\nhọc tập của bạn.',
            ),
          ],
          gap: desktop ? 20 : 24,
          crossAxisAlignment: desktop
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
        );
        final credentials = VStack([
          if (isRegister)
            RecallField(
              'Họ và tên',
              hint: 'Nguyễn Minh Anh',
              onChanged: (v) => DemoScope.of(context).name = v,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Nhập họ và tên.' : null,
            ),
          RecallField(
            'Email',
            roomy: true,
            hint: 'Email',
            prefix: const Padding(
              padding: EdgeInsets.all(16),
              child: FigmaImage('imgIconMail', screen: 'M03', width: 20),
            ),
            validator: (v) =>
                v == null || !v.contains('@') ? 'Nhập email hợp lệ.' : null,
          ),
          RecallField(
            'Mật khẩu',
            roomy: true,
            hint: 'Mật khẩu',
            obscure: hidden,
            prefix: const Padding(
              padding: EdgeInsets.all(16),
              child: FigmaImage('imgIconLock', screen: 'M03', width: 20),
            ),
            trailing: IconButton(
              tooltip: hidden ? 'Hiện mật khẩu' : 'Ẩn mật khẩu',
              onPressed: () => _refresh(() => hidden = !hidden),
              icon: const FigmaImage('imgIconEye', screen: 'M03'),
            ),
            validator: (v) =>
                v == null || v.length < 6 ? 'Nhập ít nhất 6 ký tự.' : null,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => recallDialog(
                context,
                'Quên mật khẩu',
                const RecallField('Email', hint: 'Nhập email của bạn'),
                actions: [
                  RecallButton(
                    'Gửi hướng dẫn',
                    onPressed: () {
                      Navigator.pop(context);
                      feedback(
                        context,
                        'Giao diện mẫu: chức năng gửi email sẽ được kết nối sau.',
                      );
                    },
                  ),
                ],
              ),
              child: const Text('Quên mật khẩu?'),
            ),
          ),
          RecallButton(
            isRegister ? 'Đăng ký' : 'Đăng nhập',
            fullWidth: true,
            onPressed: () {
              if (formKey.currentState!.validate()) {
                go(context, '/role');
              }
            },
          ),
          const Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Muted('Hoặc'),
              ),
              Expanded(child: Divider()),
            ],
          ),
          RecallButton(
            'G    Tiếp tục với Google',
            outlined: true,
            fullWidth: true,
            onPressed: () {
              feedback(
                context,
                'Đang xem giao diện mẫu, chưa đăng nhập Google.',
              );
              go(context, '/role');
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Muted(isRegister ? 'Đã có tài khoản?' : 'Chưa có tài khoản?'),
              TextButton(
                onPressed: () =>
                    go(context, isRegister ? '/login' : '/register'),
                child: Text(isRegister ? 'Đăng nhập' : 'Đăng ký ngay'),
              ),
            ],
          ),
          TextButton(
            onPressed: () => go(context, '/student/dashboard'),
            child: const Text('Xem giao diện mẫu'),
          ),
        ], gap: gap);
        if (!desktop) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: VStack([branding, credentials], gap: 24),
            ),
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: branding),
            SizedBox(width: (constraints.maxWidth * .08).clamp(40, 88)),
            Expanded(child: credentials),
          ],
        );
      },
    );
  }
}
