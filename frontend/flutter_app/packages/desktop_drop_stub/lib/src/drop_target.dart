import "package:flutter/widgets.dart";

class DropTarget extends StatelessWidget {
  const DropTarget({
    super.key,
    required this.child,
    this.onDragDone,
    this.onDragEntered,
    this.onDragExited,
    this.onDragUpdated,
    this.enable = true,
  });

  final Widget child;
  final Function(dynamic)? onDragDone;
  final Function(dynamic)? onDragEntered;
  final Function(dynamic)? onDragExited;
  final Function(dynamic)? onDragUpdated;
  final bool enable;

  @override
  Widget build(BuildContext context) => child;
}
