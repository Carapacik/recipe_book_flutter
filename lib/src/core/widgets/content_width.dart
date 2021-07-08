import 'package:flutter/material.dart';
import 'package:recipe_book_flutter/src/core/layout/window_size_class.dart';

class const ContentWidth({
  required final Widget child,
  final double maxWidth = 1440,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowWidthClass widthClass = AppBreakpoints.widthClassOf(context);
    final double padding = switch (widthClass) {
      WindowWidthClass.compact => 16.0,
      WindowWidthClass.medium => 24.0,
      WindowWidthClass.expanded => 40.0,
    };
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: EdgeInsets.all(padding), child: child),
      ),
    );
  }
}
