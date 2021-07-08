import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:recipe_book_flutter/src/core/theme/app_colors.dart';

class const GlassPanel({
  required final Widget child,
  final EdgeInsetsGeometry? padding,
  final BorderRadius borderRadius = const BorderRadius.all(Radius.circular(28)),
  final double blur = 24,
  final Color? color,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shape = RoundedSuperellipseBorder(
      borderRadius: borderRadius,
      side: BorderSide(color: AppColors.orange.withAlpha(58), width: 1.15),
    );
    return ClipRSuperellipse(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color ?? Colors.white.withAlpha(205),
                (color ?? AppColors.cream).withAlpha(150),
              ],
            ),
            shape: shape,
            shadows: [
              BoxShadow(
                color: AppColors.ink.withAlpha(18),
                blurRadius: 32,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
        ),
      ),
    );
  }
}

class const GlassBackground({required final Widget child, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFFFFCF4), Color(0xFFFFF4D8)],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned(
            top: -180,
            right: -100,
            child: _AmbientGlow(color: AppColors.gold, size: 460),
          ),
          const Positioned(
            bottom: -220,
            left: -160,
            child: _AmbientGlow(color: AppColors.rose, size: 520),
          ),
          const Positioned(
            top: 280,
            left: 120,
            child: _AmbientGlow(color: AppColors.cream, size: 300),
          ),
          child,
        ],
      ),
    );
  }
}

class const _AmbientGlow({
  required final Color color,
  required final double size,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
        child: SizedBox.square(
          dimension: size,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color.withAlpha(82),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
