import 'dart:typed_data';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/widgets.dart';

// ─── DropItemFile ─────────────────────────────────────────────────────────────
/// Stub implementation of desktop_drop's DropItemFile.
/// Extends [XFile] so it is assignable wherever [XFile] is expected.
class DropItemFile extends XFile {
  DropItemFile.fromData(
    Uint8List data, {
    required String name,
    required String path,
    required int length,
  })  : _storedLength = length,
        super(path, name: name, length: length, bytes: data);

  final int _storedLength;

  @override
  Future<int> length() async => _storedLength;

  @override
  Future<Uint8List> readAsBytes() async =>
      await super.readAsBytes();
}

// ─── DropDoneDetails ─────────────────────────────────────────────────────────
/// Stub implementation of desktop_drop's DropDoneDetails.
class DropDoneDetails {
  const DropDoneDetails({
    required this.files,
    required this.localPosition,
    required this.globalPosition,
  });

  final List<DropItemFile> files;
  final Offset localPosition;
  final Offset globalPosition;
}

// ─── DropTarget ───────────────────────────────────────────────────────────────
/// No-op drop-target widget for platforms where desktop_drop is unavailable.
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
  final void Function(DropDoneDetails)? onDragDone;
  final Function(dynamic)? onDragEntered;
  final Function(dynamic)? onDragExited;
  final Function(dynamic)? onDragUpdated;
  final bool enable;

  @override
  Widget build(BuildContext context) => child;
}
