import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../design/recall_theme.dart';
import 'layout.dart';

/// Vertical bar chart with optional value labels and axis labels.
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

/// Segmented arc ring showing a percentage (0–100).
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
