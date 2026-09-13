import 'package:flutter/material.dart';

class SkeletonLoaderCard extends StatelessWidget {
  const SkeletonLoaderCard({super.key, required int height});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 4 card skeleton
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.15,
            ),
            itemCount: 4,
            itemBuilder: (context, index) => _buildGridSkeletonCard(),
          ),
          const SizedBox(height: 24),

          /// resent task card skeleton
          _buildListSkeletonCard(),
          const SizedBox(height: 12),
          _buildListSkeletonCard(),
        ],
      ),
    );
  }

  /// custom skeleton box
  Widget _buildSkeletonBox({
    required double height,
    required double width,
    double borderRadius = 8,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFFE8ECE8),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  /// grid card skeleton
  Widget _buildGridSkeletonCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEFEA).withValues(alpha:0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSkeletonBox(height: 36, width: 36, borderRadius: 10),
          const Spacer(),
          _buildSkeletonBox(height: 18, width: 40, borderRadius: 4),
          const SizedBox(height: 8),
          _buildSkeletonBox(height: 12, width: 80, borderRadius: 4),
        ],
      ),
    );
  }

  /// task card skeleton
  Widget _buildListSkeletonCard() {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8ECE9), width: 1.5),
      ),
      child: Row(
        children: [
          _buildSkeletonBox(height: 36, width: 36, borderRadius: 10),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSkeletonBox(height: 12, width: 160, borderRadius: 4),
              const SizedBox(height: 8),
              _buildSkeletonBox(height: 10, width: 100, borderRadius: 4),
            ],
          ),
        ],
      ),
    );
  }
}