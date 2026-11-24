import 'package:flutter/material.dart';
import '../models/demo_store.dart';

/// Navigate to [route] unless an exam is in progress (guard) or we are already
/// on the same route (dedup).
void go(BuildContext context, String route) {
  if (DemoScope.of(context).examInProgress && route != '/student/quiz') return;
  if (ModalRoute.of(context)?.settings.name != route) {
    Navigator.of(context).pushNamed(route);
  }
}

/// Show a floating snack-bar with [text].
void feedback(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
