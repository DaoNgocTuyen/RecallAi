import 'package:flutter/material.dart';
import '../design/recall_theme.dart';

/// Vertical stack with uniform gap between children.
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

/// Wrapping row of action widgets.
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

/// Two-or-more columns that collapse to a single column below [breakpoint].
/// On desktop each column stretches to equal height via [IntrinsicHeight].
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

/// Responsive grid that fills [columns] columns down to [minWidth] per cell.
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

/// Section heading that switches between titleMedium and headlineMedium.
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

/// De-emphasised body text.
class Muted extends StatelessWidget {
  const Muted(this.text, {super.key, this.small = false});
  final String text;
  final bool small;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: small
        ? Theme.of(context).textTheme.bodySmall
        : Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: RecallColors.muted,
          ),
  );
}

/// Small badge / tag pill.
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
