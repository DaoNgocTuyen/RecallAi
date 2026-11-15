import 'dart:async';
import 'package:flutter/material.dart';
import 'package:recallai_frontend/design/recall_theme.dart';
import 'package:recallai_frontend/platform/exam_fullscreen/exam_fullscreen_driver.dart';
import 'package:recallai_frontend/widgets/recall_widgets.dart';

class FocusedExamScaffold extends StatefulWidget {
  const FocusedExamScaffold({
    super.key,
    required this.driver,
    required this.title,
    required this.submitted,
    required this.child,
  });
  final ExamFullscreenDriver driver;
  final String title;
  final bool submitted;
  final Widget child;
  @override
  State<FocusedExamScaffold> createState() => _FocusedExamScaffoldState();
}

class _FocusedExamScaffoldState extends State<FocusedExamScaffold> {
  bool entering = false;
  String? error;
  @override
  void initState() {
    super.initState();
    widget.driver.addListener(_changed);
    widget.driver.guardUnload(!widget.submitted);
    if (!widget.driver.requiresUserActivation) unawaited(widget.driver.enter());
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(covariant FocusedExamScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.driver.guardUnload(!widget.submitted);
  }

  @override
  void dispose() {
    widget.driver.removeListener(_changed);
    widget.driver.guardUnload(false);
    super.dispose();
  }

  Future<void> _enter() async {
    if (entering) return;
    setState(() {
      entering = true;
      error = null;
    });
    final success = await widget.driver.enter();
    if (!mounted) return;
    setState(() {
      entering = false;
      if (!success) {
        error = widget.driver.supported
            ? 'Chưa bật được toàn màn hình. Vui lòng thử lại và cho phép trình duyệt mở toàn màn hình.'
            : 'Trình duyệt chưa hỗ trợ chế độ này. Vui lòng mở bài thi bằng Chrome hoặc Edge hỗ trợ toàn màn hình.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final paused = !widget.submitted && !widget.driver.active;
    return PopScope<void>(
      canPop: widget.submitted,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && !widget.submitted) {
          feedback(context, 'Hãy nộp bài để kết thúc phiên làm bài.');
        }
      },
      child: Scaffold(
        backgroundColor: RecallColors.background,
        body: SafeArea(
          child: paused
              ? _gate()
              : Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: RecallColors.border),
                        ),
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1440),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.lock_outline,
                                color: RecallColors.green,
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  widget.title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              if (MediaQuery.sizeOf(context).width >= 700)
                                const Pill(
                                  'Toàn màn hình · Nộp bài để kết thúc',
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(
                          MediaQuery.sizeOf(context).width >= 700 ? 32 : 16,
                        ),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1440),
                            child: widget.child,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _gate() => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: RecallCard(
          child: VStack([
            const Icon(Icons.fullscreen, size: 56, color: RecallColors.green),
            const SectionTitle('Bài thi yêu cầu toàn màn hình', large: true),
            const Text(
              'Bật toàn màn hình để bắt đầu hoặc tiếp tục làm bài. Bạn chỉ kết thúc phiên làm bài sau khi xác nhận nộp bài.',
            ),
            const Muted(
              'Nếu vừa thoát toàn màn hình, câu trả lời vẫn được giữ trong phiên này.',
            ),
            if (error != null)
              Text(error!, style: const TextStyle(color: RecallColors.error)),
            RecallButton(
              entering ? 'Đang mở…' : 'Vào toàn màn hình để làm bài',
              fullWidth: true,
              onPressed: entering ? null : _enter,
            ),
          ], gap: 20),
        ),
      ),
    ),
  );
}
