import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../design/recall_theme.dart';
import '../models/demo_store.dart';

void go(BuildContext context, String route) {
  if (DemoScope.of(context).examInProgress && route != '/student/quiz') return;
  if (ModalRoute.of(context)?.settings.name != route) {
    Navigator.of(context).pushNamed(route);
  }
}

void feedback(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

class RecallButton extends StatelessWidget {
  const RecallButton(
    this.label, {
    super.key,
    this.onPressed,
    this.secondary = false,
    this.outlined = false,
    this.quiet = false,
    this.danger = false,
    this.fullWidth = false,
    this.leading,
    this.compact = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool secondary, outlined, quiet, danger, fullWidth, compact;
  final Widget? leading;
  @override
  Widget build(BuildContext context) {
    final primary = !secondary && !outlined && !quiet && !danger;
    return Semantics(
      button: true,
      enabled: onPressed != null,
      child: Opacity(
        opacity: onPressed == null ? .45 : 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: primary
                ? const LinearGradient(
                    colors: [RecallColors.primary, Color(0xFF84EFD8)],
                  )
                : null,
            color: primary
                ? null
                : secondary
                ? RecallColors.mint
                : danger
                ? RecallColors.error.withValues(alpha: .1)
                : outlined
                ? Colors.white
                : Colors.transparent,
            borderRadius: BorderRadius.circular(fullWidth ? 999 : 12),
            border: outlined ? Border.all(color: RecallColors.border) : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(fullWidth ? 999 : 12),
              onTap: onPressed,
              child: Container(
                width: fullWidth ? double.infinity : null,
                constraints: BoxConstraints(
                  minHeight: fullWidth ? 56 : 44,
                  minWidth: compact ? 64 : 88,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (leading != null) ...[
                      leading!,
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.57,
                          fontWeight: FontWeight.w600,
                          color: danger ? RecallColors.error : RecallColors.ink,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RecallCard extends StatelessWidget {
  const RecallCard({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.padding = 24,
    this.onTap,
  });
  final Widget child;
  final Color color;
  final double padding;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 0),
    decoration: BoxDecoration(
      color: color,
      border: Border.all(color: RecallColors.border),
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0F0D4033),
          offset: Offset(0, 4),
          blurRadius: 16,
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: SizedBox(
            width: double.infinity,
            child: child,
          ),
        ),
      ),
    ),
  );
}

class VStack extends StatelessWidget {
  const VStack(
    this.children, {
    super.key,
    this.gap = 16,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });
  final List<Widget> children;
  final double gap;
  final CrossAxisAlignment crossAxisAlignment;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: crossAxisAlignment,
    children: [
      for (var i = 0; i < children.length; i++) ...[
        if (i > 0) SizedBox(height: gap),
        children[i],
      ],
    ],
  );
}

class ActionGroup extends StatelessWidget {
  const ActionGroup(this.children, {super.key, this.spacing = 16});
  final List<Widget> children;
  final double spacing;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: spacing,
    runSpacing: 12,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: children,
  );
}

class AdaptiveColumns extends StatelessWidget {
  const AdaptiveColumns(
    this.children, {
    super.key,
    this.flex = const [],
    this.breakpoint = 850,
  });
  final List<Widget> children;
  final List<int> flex;
  final double breakpoint;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) => c.maxWidth < breakpoint
        ? VStack(children, gap: 24)
        : IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  if (i > 0) const SizedBox(width: 24),
                  Expanded(flex: flex.isEmpty ? 1 : flex[i], child: children[i]),
                ],
              ],
            ),
          ),
  );
}

class AdaptiveGrid extends StatelessWidget {
  const AdaptiveGrid(
    this.children, {
    super.key,
    this.columns = 3,
    this.minWidth = 240,
    this.gap = 24,
  });
  final List<Widget> children;
  final int columns;
  final double minWidth, gap;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) {
      final cols = ((c.maxWidth + gap) / (minWidth + gap)).floor().clamp(
        1,
        columns,
      );
      final width = (c.maxWidth - (cols - 1) * gap) / cols;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: children
            .map((child) => SizedBox(width: width, child: child))
            .toList(),
      );
    },
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.large = false});
  final String text;
  final bool large;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: large
        ? Theme.of(context).textTheme.headlineMedium
        : Theme.of(context).textTheme.titleMedium,
  );
}

class Muted extends StatelessWidget {
  const Muted(this.text, {super.key, this.small = false});
  final String text;
  final bool small;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: small
        ? Theme.of(context).textTheme.bodySmall
        : Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(color: RecallColors.muted),
  );
}

class Pill extends StatelessWidget {
  const Pill(this.label, {super.key, this.error = false});
  final String label;
  final bool error;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: error
          ? RecallColors.error.withValues(alpha: .1)
          : RecallColors.mint,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 12,
        height: 1.5,
        color: error ? RecallColors.error : RecallColors.green,
      ),
    ),
  );
}

class Metric extends StatelessWidget {
  const Metric(this.value, this.label, {super.key, this.detail});
  final String value, label;
  final String? detail;
  @override
  Widget build(BuildContext context) => RecallCard(
    child: VStack([
      Text(
        value,
        style: Theme.of(
          context,
        ).textTheme.headlineLarge!.copyWith(color: RecallColors.green),
      ),
      Muted(label, small: true),
      if (detail != null) Muted(detail!, small: true),
    ]),
  );
}

// ─── RecallSelect ────────────────────────────────────────────────────────────
/// Custom animated dropdown – bo góc, shadow nhẹ, chevron animation mượt.
class RecallSelect extends StatefulWidget {
  const RecallSelect({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label,
    this.hint,
  });
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final String? label;
  final String? hint;

  @override
  State<RecallSelect> createState() => _RecallSelectState();
}

class _RecallSelectState extends State<RecallSelect>
    with SingleTickerProviderStateMixin {
  final _key = GlobalKey();
  OverlayEntry? _overlay;
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _slide;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<double>(begin: -6, end: 0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _close(animate: false);
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() => _open ? _close() : _show();

  void _show() {
    final box = _key.currentContext!.findRenderObject() as RenderBox;
    final pos = box.localToGlobal(Offset.zero);
    final size = box.size;
    final overlay = Overlay.of(context);
    _overlay = OverlayEntry(
      builder: (_) => Stack(
        children: [
          // tap outside → close
          Positioned.fill(
            child: GestureDetector(
              onTap: _close,
              behavior: HitTestBehavior.translucent,
            ),
          ),
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, child) => Positioned(
              top: pos.dy + size.height + 6 + _slide.value,
              left: pos.dx,
              width: size.width,
              child: Opacity(opacity: _fade.value, child: child),
            ),
            child: _DropPanel(
              items: widget.items,
              selected: widget.value,
              onSelect: (v) {
                _close();
                widget.onChanged(v);
              },
            ),
          ),
        ],
      ),
    );
    overlay.insert(_overlay!);
    setState(() => _open = true);
    _ctrl.forward(from: 0);
  }

  Future<void> _close({bool animate = true}) async {
    if (_overlay == null) return;
    if (animate) {
      await _ctrl.reverse();
    }
    _overlay?.remove();
    _overlay = null;
    if (mounted) setState(() => _open = false);
  }

  @override
  Widget build(BuildContext context) {
    final column = widget.label != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _trigger(),
            ],
          )
        : _trigger();
    return column;
  }

  Widget _trigger() {
    final display = widget.hint != null && widget.value.isEmpty
        ? widget.hint!
        : widget.value;
    final isHint = widget.hint != null && widget.value.isEmpty;
    return GestureDetector(
      key: _key,
      onTap: _toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _open ? RecallColors.green : RecallColors.border,
            width: _open ? 1.5 : 1,
          ),
          boxShadow: _open
              ? [
                  BoxShadow(
                    color: RecallColors.green.withValues(alpha: .10),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                display,
                style: TextStyle(
                  fontSize: 14,
                  color: isHint ? RecallColors.muted : RecallColors.ink,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AnimatedRotation(
              turns: _open ? 0.5 : 0,
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeInOut,
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: RecallColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DropPanel extends StatelessWidget {
  const _DropPanel({
    required this.items,
    required this.selected,
    required this.onSelect,
  });
  final List<String> items;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(14),
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: RecallColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A0D4033),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: items.map((item) {
            final isSelected = item == selected;
            return _DropItem(
              label: item,
              selected: isSelected,
              onTap: () => onSelect(item),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _DropItem extends StatefulWidget {
  const _DropItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_DropItem> createState() => _DropItemState();
}

class _DropItemState extends State<_DropItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: widget.selected
              ? RecallColors.mint
              : _hovered
              ? RecallColors.background
              : Colors.white,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: widget.selected
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: widget.selected
                        ? RecallColors.green
                        : RecallColors.ink,
                  ),
                ),
              ),
              if (widget.selected)
                const Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: RecallColors.green,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
// ─────────────────────────────────────────────────────────────────────────────

class RecallField extends StatelessWidget {
  const RecallField(
    this.label, {
    super.key,
    this.controller,
    this.initial,
    this.hint,
    this.lines = 1,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
    this.obscure = false,
    this.validator,
    this.trailing,
    this.prefix,
    this.roomy = false,
  });
  final String label;
  final TextEditingController? controller;
  final String? initial, hint;
  final int lines;
  final ValueChanged<String>? onChanged;
  final bool readOnly, obscure, roomy;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final Widget? trailing, prefix;
  @override
  Widget build(BuildContext context) => VStack([
    Text(
      label,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
    TextFormField(
      controller: controller,
      initialValue: controller == null ? initial : null,
      obscureText: obscure,
      style: Theme.of(context).textTheme.bodyMedium,
      maxLines: obscure ? 1 : lines,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        contentPadding: roomy
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 19)
            : null,
        hintText: hint,
        suffixIcon: trailing,
        prefixIcon: prefix,
      ),
    ),
  ], gap: 8);
}

Future<T?> recallDialog<T>(
  BuildContext context,
  String title,
  Widget content, {
  List<Widget> actions = const [],
}) => showDialog<T>(
  context: context,
  builder: (ctx) => Dialog(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 640),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: VStack([
          Row(
            children: [
              Expanded(child: SectionTitle(title, large: true)),
              IconButton(
                tooltip: 'Đóng',
                onPressed: () => Navigator.pop(ctx),
                icon: const Icon(Icons.close, size: 20),
              ),
            ],
          ),
          content,
          if (actions.isNotEmpty) ActionGroup(actions),
        ]),
      ),
    ),
  ),
);

class BarChart extends StatelessWidget {
  const BarChart({
    super.key,
    this.values = const [35, 50, 42, 60, 48, 75, 70],
    this.labels = const ['T5', 'T6', 'T7', 'CN', 'T2', 'T3', 'T4'],
  });
  final List<double> values;
  final List<String> labels;
  @override
  Widget build(BuildContext context) {
    final max = values.reduce(math.max);
    return SizedBox(
      height: MediaQuery.sizeOf(context).width < 600 ? 200 : 180,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < values.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: VStack([
                  Muted(values[i].toInt().toString(), small: true),
                  Container(
                    height: values[i] / max * 112,
                    decoration: BoxDecoration(
                      color: RecallColors.primaryDark,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  Text(
                    labels[i],
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ], gap: 8),
              ),
            ),
        ],
      ),
    );
  }
}

class AccuracyRing extends StatelessWidget {
  const AccuracyRing(this.percent, {super.key, this.size = 144});
  final int percent;
  final double size;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: CustomPaint(
      painter: _RingPainter(percent),
      child: Center(
        child: Text(
          '$percent%',
          style: Theme.of(
            context,
          ).textTheme.headlineLarge!.copyWith(color: RecallColors.green),
        ),
      ),
    ),
  );
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.percent);
  final int percent;
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(6, 6, size.width - 12, size.height - 12);
    for (var i = 0; i < 20; i++) {
      canvas.drawArc(
        rect,
        -math.pi / 2 + i * math.pi / 10,
        math.pi / 10 - .025,
        false,
        Paint()
          ..color = i < (percent / 5).round()
              ? RecallColors.green
              : RecallColors.mint
          ..style = PaintingStyle.stroke
          ..strokeWidth = 11,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      percent != oldDelegate.percent;
}

class EmptyPanel extends StatelessWidget {
  const EmptyPanel(this.title, this.description, {super.key, this.action});
  final String title, description;
  final Widget? action;
  @override
  Widget build(BuildContext context) => RecallCard(
    child: SizedBox(
      width: double.infinity,
      child: VStack([
        const FigmaImage('imgBiuTngFile', width: 32),
        SectionTitle(title),
        Muted(description),
        ?action,
      ]),
    ),
  );
}

const studentNav = [
  ('Tổng quan', 'home', '/student/dashboard'),
  ('Tài liệu', 'file', '/student/documents'),
  ('Luyện tập AI', 'spark', '/student/studio'),
  ('Flashcard', 'cards', '/student/decks'),
  ('Lịch ôn tập', 'calendar', '/student/review'),
  ('Thống kê', 'chart', '/student/analytics'),
  ('Kế hoạch ôn thi', 'clock', '/student/planner'),
  ('Lớp học', 'cap', '/student/classes'),
  ('Cài đặt', 'settings', '/settings'),
];
const teacherNav = [
  ('Tổng quan', 'home', '/teacher/dashboard'),
  ('Lớp học', 'cap', '/teacher/classes'),
  ('Ngân hàng câu hỏi', 'book', '/teacher/questions'),
  ('Bài kiểm tra', 'file', '/teacher/quizzes'),
  ('Chấm điểm', 'check', '/teacher/grading'),
  ('Thống kê', 'chart', '/teacher/analytics'),
  ('Đề xuất ôn tập', 'spark', '/teacher/recommendations'),
  ('Cài đặt', 'settings', '/settings'),
];

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.title,
    required this.child,
    this.teacher = false,
    this.active = 0,
    this.subtitle,
  });
  final String title;
  final Widget child;
  final bool teacher;
  final int active;
  final String? subtitle;
  @override
  Widget build(BuildContext context) {
    final store = DemoScope.of(context),
        desktop = MediaQuery.sizeOf(context).width >= 1000;
    final nav = teacher ? teacherNav : studentNav;
    final routeSection = ModalRoute.of(context)?.settings.name?.split('/').last;
    final teacherScreen =
        const {
          'dashboard': 'T01',
          'classes': 'T02',
          'classroom': 'T03',
          'generate': 'T04',
          'questions': 'T05',
          'edit': 'T06',
          'builder': 'T07',
          'assign': 'T08',
          'quizzes': 'T09',
          'grading': 'T10',
          'analytics': 'T11',
          'recommendations': 'T12',
        }[routeSection] ??
        'T01';
    Widget sidebar({bool drawer = false}) => SizedBox(
      width: drawer || !store.sidebarCollapsed ? 248 : 80,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(right: BorderSide(color: RecallColors.border)),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: drawer || !store.sidebarCollapsed ? 24 : 16,
              vertical: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const RecallRobot(size: 24),
                    if (drawer || !store.sidebarCollapsed) ...[
                      const SizedBox(width: 8),
                      const Text(
                        'RecallAI',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
                if (drawer || !store.sidebarCollapsed)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      teacher ? 'KHÔNG GIAN GIÁO VIÊN' : 'KHÔNG GIAN HỌC TẬP',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall!.copyWith(fontSize: 10),
                    ),
                  ),
                const SizedBox(height: 32),
                for (var i = 0; i < nav.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Material(
                      color: i == active
                          ? RecallColors.mint
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          if (drawer) Navigator.pop(context);
                          go(context, nav[i].$3);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              FigmaImage(
                                'imgBiuTng${nav[i].$2[0].toUpperCase()}${nav[i].$2.substring(1)}',
                                screen: teacher ? teacherScreen : 'S01',
                              ),
                              if (drawer || !store.sidebarCollapsed) ...[
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    nav[i].$1,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: teacher && i != active
                                          ? RecallColors.muted
                                          : RecallColors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                const Spacer(),
                if (drawer || !store.sidebarCollapsed)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: RecallColors.background,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: VStack([
                      Text(
                        teacher ? 'Nguyễn Văn A' : store.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Muted(
                        teacher
                            ? 'Giáo viên · Cộng tác giảng dạy'
                            : 'Dữ liệu mẫu',
                        small: true,
                      ),
                    ], gap: 8),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    return Scaffold(
      drawer: desktop ? null : Drawer(child: sidebar(drawer: true)),
      bottomNavigationBar: desktop || teacher
          ? null
          : NavigationBar(
              height: 72,
              selectedIndex: active == 0
                  ? 0
                  : active == 1
                  ? 1
                  : active == 2
                  ? 2
                  : active == 3 || active == 4
                  ? 3
                  : 4,
              onDestinationSelected: (i) => go(
                context,
                [
                  '/student/dashboard',
                  '/student/documents',
                  '/student/studio',
                  '/student/review',
                  '/settings',
                ][i],
              ),
              backgroundColor: Colors.white,
              indicatorColor: RecallColors.mint,
              destinations: const [
                NavigationDestination(
                  icon: FigmaImage('imgBiuTngHome'),
                  label: 'Tổng quan',
                ),
                NavigationDestination(
                  icon: FigmaImage('imgBiuTngFile'),
                  label: 'Tài liệu',
                ),
                NavigationDestination(
                  icon: FigmaImage('imgBiuTngSpark'),
                  label: 'Luyện tập',
                ),
                NavigationDestination(
                  icon: FigmaImage('imgBiuTngClock'),
                  label: 'Ôn tập',
                ),
                NavigationDestination(
                  icon: FigmaImage('imgBiuTngSettings'),
                  label: 'Cá nhân',
                ),
              ],
            ),
      body: Row(
        children: [
          if (desktop) sidebar(),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: desktop ? 80 : 64,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: RecallColors.border),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: desktop ? 24 : 12),
                  child: Row(
                    children: [
                      Builder(
                        builder: (ctx) => IconButton(
                          tooltip: 'Menu',
                          onPressed: () {
                            if (desktop) {
                              store.sidebarCollapsed = !store.sidebarCollapsed;
                              store.update();
                            } else {
                              Scaffold.of(ctx).openDrawer();
                            }
                          },
                          icon: const Icon(Icons.menu, size: 20),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          desktop
                              ? '${teacher ? 'Không gian giáo viên' : 'Sinh viên'} / $title'
                              : title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: desktop ? 14 : 16,
                            color: desktop
                                ? RecallColors.muted
                                : RecallColors.ink,
                            fontWeight: desktop
                                ? FontWeight.w400
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                      if (desktop)
                        SizedBox(
                          width: 340,
                          child: InkWell(
                            onTap: () => _search(context),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: RecallColors.background,
                                border: Border.all(color: RecallColors.border),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                children: [
                                  FigmaImage('imgBiuTngSearch'),
                                  SizedBox(width: 12),
                                  Flexible(
                                    child: Muted(
                                      'Tìm tài liệu, thẻ ghi nhớ…',
                                      small: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(width: 16),
                      IconButton(
                        tooltip: 'Thông báo',
                        onPressed: () => recallDialog(
                          context,
                          'Thông báo',
                          const VStack([
                            Pill('24 thẻ cần ôn hôm nay'),
                            Text(
                              'Giáo viên nhắc ôn SQL JOIN trước bài kiểm tra.',
                            ),
                          ]),
                        ),
                        icon: FigmaImage(
                          'imgBiuTngBell',
                          screen: teacher ? teacherScreen : 'S01',
                          width: teacher ? 24 : 20,
                        ),
                      ),
                      PopupMenuButton<String>(
                        tooltip: 'Tài khoản',
                        onSelected: (v) {
                          if (v == 'teacher' || v == 'student') {
                            store.setRole(v == 'teacher');
                            go(context, '/$v/dashboard');
                          } else {
                            go(context, v);
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: '/settings',
                            child: Text('Cài đặt tài khoản'),
                          ),
                          PopupMenuItem(
                            value: 'student',
                            child: Text('Giao diện sinh viên'),
                          ),
                          PopupMenuItem(
                            value: 'teacher',
                            child: Text('Giao diện giáo viên'),
                          ),
                          PopupMenuItem(
                            value: '/login',
                            child: Text('Đăng xuất'),
                          ),
                        ],
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: RecallColors.mint,
                          child: Text(
                            teacher ? 'NA' : 'MA',
                            style: const TextStyle(
                              fontSize: 12,
                              color: RecallColors.ink,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: PageStorageKey(title),
                    padding: EdgeInsets.all(desktop ? 32 : 24),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1128),
                        child: SizedBox(
                          width: double.infinity,
                          child: VStack([
                            Text(
                              title,
                              style: desktop
                                  ? Theme.of(context).textTheme.headlineLarge
                                  : Theme.of(context).textTheme.headlineMedium,
                            ),
                            if (subtitle != null) Muted(subtitle!),
                            child,
                          ], gap: 24),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _search(BuildContext context) => recallDialog(
    context,
    'Tìm trong không gian học tập',
    VStack([
      const RecallField('Từ khóa', hint: 'Tìm tài liệu, bộ thẻ…'),
      for (final (label, route) in [
        ('Cơ sở dữ liệu.pdf', '/student/pdf'),
        ('Thuật ngữ Cơ sở dữ liệu', '/student/decks'),
        ('Kiểm tra chương 2 – SQL', '/student/classes'),
      ])
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(label),
          trailing: const Icon(Icons.arrow_forward, size: 18),
          onTap: () {
            Navigator.pop(context);
            go(context, route);
          },
        ),
    ]),
  );
}
