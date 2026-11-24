import 'package:flutter/material.dart';
import '../design/recall_theme.dart';
import 'layout.dart';

/// Base card with rounded corners, border, and shadow.
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
          child: child,
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
