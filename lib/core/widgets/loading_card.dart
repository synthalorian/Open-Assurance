import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_colors.dart';

class LoadingCard extends StatelessWidget {
  final double height;
  final double width;
  final double radius;

  const LoadingCard({
    super.key,
    this.height = 200,
    this.width = double.infinity,
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.surface : Colors.grey[300]!;
    final highlightColor = isDark ? AppColors.surfaceVariant : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
