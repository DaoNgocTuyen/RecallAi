import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../design/recall_theme.dart';

// ─── VStack ───────────────────────────────────────────────────────────────────

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

// ─── ActionGroup ──────────────────────────────────────────────────────────────

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

// ─── EqualHeightRow ───────────────────────────────────────────────────────────

/// A [Row]-like widget that makes every child the same height as the tallest
/// sibling — without using [IntrinsicHeight].
///
/// **Why not [IntrinsicHeight]?**
/// [IntrinsicHeight] delegates to each child's `computeDryLayout` path, which
/// is not supported by scrollable widgets ([SingleChildScrollView], [ListView],
/// etc.). Using it inside a page that contains a scroll view causes a
/// `'hasSize' assertion` failure in tests.
///
/// **How this works**
/// [_EqualHeightRowRender] performs a true 2-pass layout:
///  1. Measure every child with tight-width / loose-height constraints and
///     record the max height.
///  2. Re-layout every child with tight-width AND tight-height (the max),
///     then position them left-to-right.
///
/// This is equivalent to what [IntrinsicHeight] achieves, but it goes through
/// the normal `performLayout` path instead of the intrinsic-size path, so it
/// is compatible with any child widget.
class EqualHeightRow extends MultiChildRenderObjectWidget {
  const EqualHeightRow({
    super.key,
    required super.children,
    this.gap = 24.0,
    this.flex = const [],
  });

  /// Horizontal gap between columns.
  final double gap;

  /// Optional flex weights — same semantics as [Expanded.flex].
  /// If empty, all columns get equal width.
  final List<int> flex;

  @override
  RenderBox createRenderObject(BuildContext context) =>
      _EqualHeightRowRender(gap: gap, flex: flex);

  @override
  void updateRenderObject(
    BuildContext context,
    RenderBox renderObject,
  ) {
    final ro = renderObject as _EqualHeightRowRender;
    ro
      ..gap = gap
      ..flex = flex;
  }
}

// Parent-data slot — stores the resolved pixel width for each child.
class _EqualHeightParentData extends ContainerBoxParentData<RenderBox> {
  double columnWidth = 0;
}

class _EqualHeightRowRender extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _EqualHeightParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _EqualHeightParentData> {
  _EqualHeightRowRender({required double gap, required List<int> flex})
    : _gap = gap,
      _flex = flex;

  double _gap;
  double get gap => _gap;
  set gap(double v) {
    if (_gap == v) return;
    _gap = v;
    markNeedsLayout();
  }

  List<int> _flex;
  List<int> get flex => _flex;
  set flex(List<int> v) {
    if (_flex == v) return;
    _flex = v;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _EqualHeightParentData) {
      child.parentData = _EqualHeightParentData();
    }
  }

  // Resolve pixel widths for each child given total available width.
  List<double> _resolveWidths(int count, double totalWidth) {
    if (count == 0) return [];
    final gapTotal = _gap * (count - 1);
    final available = totalWidth - gapTotal;
    if (_flex.length == count) {
      final totalFlex = _flex.fold<int>(0, (s, f) => s + f);
      return List.generate(
        count,
        (i) => (available * _flex[i] / totalFlex).floorToDouble(),
      );
    }
    final each = (available / count).floorToDouble();
    return List.filled(count, each);
  }

  @override
  void performLayout() {
    final count = childCount;
    if (count == 0) {
      size = constraints.smallest;
      return;
    }

    final widths = _resolveWidths(count, constraints.maxWidth);

    // ── Pass 1: measure natural height of each child ──────────────────────
    double maxHeight = 0;
    RenderBox? child = firstChild;
    var i = 0;
    while (child != null) {
      final w = widths[i++];
      child.layout(
        BoxConstraints(minWidth: w, maxWidth: w),
        parentUsesSize: true,
      );
      if (child.size.height > maxHeight) maxHeight = child.size.height;
      (child.parentData as _EqualHeightParentData).columnWidth = w;
      child = childAfter(child);
    }

    // ── Pass 2: re-layout with tight height so every child fills max ──────
    double dx = 0;
    child = firstChild;
    i = 0;
    while (child != null) {
      final w = widths[i++];
      child.layout(
        BoxConstraints.tight(Size(w, maxHeight)),
        parentUsesSize: true,
      );
      final pd = child.parentData as _EqualHeightParentData;
      pd.offset = Offset(dx, 0);
      dx += w + _gap;
      child = childAfter(child);
    }

    size = constraints.constrain(Size(constraints.maxWidth, maxHeight));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
}

// ─── AdaptiveColumns ──────────────────────────────────────────────────────────

/// Two-or-more columns that collapse to a single column below [breakpoint].
///
/// On desktop (width ≥ [breakpoint]) uses [EqualHeightRow] so all cards in
/// the same row share the same height — without using [IntrinsicHeight].
/// On mobile collapses to [VStack].
class AdaptiveColumns extends StatelessWidget {
  const AdaptiveColumns(
    this.children, {
    super.key,
    this.flex = const [],
    this.breakpoint = 460,
  });
  final List<Widget> children;
  final List<int> flex;
  final double breakpoint;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) {
      if (!c.maxWidth.isFinite || c.maxWidth < breakpoint) {
        return VStack(children, gap: 24);
      }
      return EqualHeightRow(gap: 24, flex: flex, children: children);
    },
  );
}

// ─── AdaptiveGrid ─────────────────────────────────────────────────────────────

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

// ─── SectionTitle ─────────────────────────────────────────────────────────────

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

// ─── Muted ────────────────────────────────────────────────────────────────────

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

// ─── Pill ─────────────────────────────────────────────────────────────────────

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
