import 'package:flutter/material.dart';
import '../design/recall_theme.dart';
import 'layout.dart';

// ─── RecallField ──────────────────────────────────────────────────────────────

/// Labelled text field wrapping [TextFormField] with the RecallAI theme.
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

// ─── RecallSelect ─────────────────────────────────────────────────────────────

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
    // Always remove overlay synchronously on dispose to prevent
    // layout errors when the widget tree is torn down during tests.
    _overlay?.remove();
    _overlay = null;
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() => _open ? _close() : _show();

  void _show() {
    final ctx = _key.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final size = box.size;
    // Skip if trigger hasn't been laid out yet (e.g. in test environments).
    if (!size.isFinite || size.isEmpty) return;
    final pos = box.localToGlobal(Offset.zero);
    final overlay = Overlay.of(context);
    _overlay = OverlayEntry(
      builder: (_) => Stack(
        children: [
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
    if (animate) await _ctrl.reverse();
    _overlay?.remove();
    _overlay = null;
    if (mounted) setState(() => _open = false);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.label != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.label!,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _trigger(),
        ],
      );
    }
    return _trigger();
  }

  Widget _trigger() {
    final isHint = widget.hint != null && widget.value.isEmpty;
    final display = isHint ? widget.hint! : widget.value;
    return Semantics(
      label: widget.label ?? 'Chọn giá trị',
      value: widget.value,
      button: true,
      child: GestureDetector(
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
  Widget build(BuildContext context) => Material(
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
          return _DropItem(
            label: item,
            selected: item == selected,
            onTap: () => onSelect(item),
          );
        }).toList(),
      ),
    ),
  );
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
  Widget build(BuildContext context) => MouseRegion(
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

// ─── recallDialog ─────────────────────────────────────────────────────────────

/// Shows a constrained modal dialog with a title, content, and optional actions.
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
