import 'package:flutter/widgets.dart';

enum WindowWidthClass() {
  compact,
  medium,
  expanded
}

abstract final class AppBreakpoints() {
  static const compact = 600.0;
  static const medium = 840.0;
  static const desktopNavigation = 1120.0;

  static WindowWidthClass widthClassOf(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    if (width < compact) {
      return WindowWidthClass.compact;
    }
    if (width < medium) {
      return WindowWidthClass.medium;
    }
    return WindowWidthClass.expanded;
  }

  static int gridColumns(double width) => switch (width) {
    < compact => 1,
    < medium => 2,
    < 1200 => 3,
    _ => 4,
  };
}
