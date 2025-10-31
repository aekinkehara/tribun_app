import 'package:flutter/material.dart';
import 'package:tribun_app/utils/app_colors.dart';

class LoadingShimmer extends StatefulWidget {
  const LoadingShimmer({super.key});

  @override
  State<LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // shimmer effect widget biar reusable
  Widget shimmerBox({
    double? height,
    double? width,
    BorderRadius? radius,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: radius ?? BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: const Alignment(-1, 0),
              end: const Alignment(2, 0),
              colors: [
                AppColors.divider.withValues(alpha: 0.4),
                AppColors.divider.withValues(alpha: 0.2),
                AppColors.divider.withValues(alpha: 0.4),
              ],
              stops: const [0.0, 0.5, 1.0],
              transform: GradientRotation(_animation.value * 3.14159),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === category selector shimmer (DI ATAS) ===
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: shimmerBox(
                    height: 36,
                    width: 80,
                    radius: BorderRadius.circular(18),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // === header welcome shimmer ===
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmerBox(
                    height: 28, width: 200, radius: BorderRadius.circular(8)),
                const SizedBox(height: 4),
                shimmerBox(
                    height: 16, width: 250, radius: BorderRadius.circular(8)),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // === carousel shimmer ===
          SizedBox(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  width: 300,
                  margin: const EdgeInsets.only(right: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        shimmerBox(
                          height: double.infinity,
                          width: double.infinity,
                          radius: BorderRadius.circular(16),
                        ),
                        // overlay shimmer untuk title + publisher + time
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.4),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                shimmerBox(
                                  height: 14,
                                  width: double.infinity,
                                  radius: BorderRadius.circular(4),
                                ),
                                const SizedBox(height: 4),
                                shimmerBox(
                                  height: 12,
                                  width: 120,
                                  radius: BorderRadius.circular(4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // === section title shimmer + line oranye placeholder ===
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmerBox(
                    height: 20, width: 120, radius: BorderRadius.circular(4)),
                const SizedBox(height: 4),
                Container(
                  height: 3,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // === news list shimmer ===
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // image shimmer
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: shimmerBox(
                        height: 90,
                        width: 120,
                        radius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // text shimmer
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          shimmerBox(height: 14, width: double.infinity),
                          const SizedBox(height: 8),
                          shimmerBox(height: 14, width: screenWidth * 0.5),
                          const SizedBox(height: 8),
                          shimmerBox(height: 12, width: screenWidth * 0.3),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
