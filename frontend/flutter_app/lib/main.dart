import 'package:flutter/material.dart';
import 'design/recall_theme.dart';
import 'recall_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DesignAssets.load();
  runApp(const RecallApp());
}
