import 'package:flutter/material.dart';
import '../design/recall_theme.dart';

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
