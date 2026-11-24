import 'package:flutter/material.dart';
import '../design/recall_theme.dart';
import 'layout.dart';

/// Base card with rounded corners, border, shadow, and full-height fill.
///
/// When placed inside [EqualHeightRow] (via [AdaptiveColumns] on desktop),
/// the card automatically stretches to match the tallest sibling because
/// [EqualHeightRow] gives every child a tight height constraint. The inner
/// [Column] with [MainAxisSize.max] fills that height, pushing the content
/// to the top and leaving whitespace at the bottom — giving the equal-height
/// appearance.
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
  Widget build(BuildContext context) => DecoratedBox(
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
          // Column with MainAxisSize.max: when EqualHeightRow gives a tight
          // height, this column fills it. When unconstrained (mobile VStack),
          // it shrink-wraps naturally.
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [child],
          ),
        ),
      ),
    ),
  );
}

/// Single KPI metric card with a large value and a subtitle label.
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

/// Full-width empty-state panel with an illustration, title, description,
/// and an optional call-to-action widget.
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
