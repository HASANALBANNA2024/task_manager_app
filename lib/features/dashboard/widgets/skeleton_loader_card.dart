import 'package:flutter/material.dart';

class SkeletonLoaderCard extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const SkeletonLoaderCard({
    super.key,
    required this.height,
    this.width = double.infinity,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFFEAEFEA),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}