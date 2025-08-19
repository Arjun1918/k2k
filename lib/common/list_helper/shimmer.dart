import 'package:flutter/material.dart';
import 'package:k2k/utils/sreen_util.dart';

class ShimmerCard extends StatefulWidget {
  const ShimmerCard({super.key});

  @override
  State<ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<ShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOutSine,
    ));
    
    _shimmerController.repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil.spacingLarge,
            vertical: ScreenUtil.spacingMedium,
          ),
          child: Card(
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ScreenUtil.borderRadiusLarge),
            ),
            child: Padding(
              padding: EdgeInsets.all(ScreenUtil.spacingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildShimmerContainer(
                          height: ScreenUtil.textSizeLarge + 4,
                          width: double.infinity,
                        ),
                      ),
                      SizedBox(width: ScreenUtil.spacingLarge),
                      Row(
                        children: List.generate(
                          3,
                          (index) => Container(
                            margin: EdgeInsets.only(left: ScreenUtil.spacingMedium),
                            child: _buildShimmerContainer(
                              width: 44,
                              height: 44,
                              borderRadius: ScreenUtil.borderRadiusMedium,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenUtil.spacingLarge),
                  ...List.generate(
                    3,
                    (index) => Padding(
                      padding: EdgeInsets.only(bottom: ScreenUtil.spacingMedium),
                      child: Row(
                        children: [
                          _buildShimmerContainer(
                            width: ScreenUtil.iconSizeSmall,
                            height: ScreenUtil.iconSizeSmall,
                            borderRadius: ScreenUtil.borderRadiusSmall,
                          ),
                          SizedBox(width: ScreenUtil.spacingMedium),
                          Expanded(
                            child: _buildShimmerContainer(
                              height: ScreenUtil.textSizeMedium,
                              width: double.infinity,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerContainer({
    required double height,
    required double width,
    double? borderRadius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          borderRadius ?? ScreenUtil.borderRadiusSmall,
        ),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [
            _shimmerAnimation.value - 0.3,
            _shimmerAnimation.value,
            _shimmerAnimation.value + 0.3,
          ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
          colors: const [
            Color(0xFFE0E0E0),
            Color(0xFFF5F5F5),
            Color(0xFFE0E0E0),
          ],
        ),
      ),
    );
  }
}

// Alternative: If you prefer to keep it as a function, here's the enhanced version:
Widget buildShimmerCard() {
  return const ShimmerCard();
}

// Or if you want a more customizable shimmer effect with different colors:
class CustomShimmerCard extends StatefulWidget {
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  const CustomShimmerCard({
    Key? key,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.duration = const Duration(milliseconds: 1500),
  }) : super(key: key);

  @override
  State<CustomShimmerCard> createState() => _CustomShimmerCardState();
}

class _CustomShimmerCardState extends State<CustomShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    ));
    
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil.spacingLarge,
            vertical: ScreenUtil.spacingMedium,
          ),
          child: Card(
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ScreenUtil.borderRadiusLarge),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ScreenUtil.borderRadiusLarge),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(ScreenUtil.spacingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _buildShimmerBox(
                                height: ScreenUtil.textSizeLarge + 4,
                              ),
                            ),
                            SizedBox(width: ScreenUtil.spacingLarge),
                            Row(
                              children: List.generate(
                                3,
                                (index) => Container(
                                  margin: EdgeInsets.only(
                                    left: ScreenUtil.spacingMedium,
                                  ),
                                  child: _buildShimmerBox(
                                    width: 44,
                                    height: 44,
                                    borderRadius: ScreenUtil.borderRadiusMedium,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ScreenUtil.spacingLarge),
                        ...List.generate(
                          3,
                          (index) => Padding(
                            padding: EdgeInsets.only(
                              bottom: ScreenUtil.spacingMedium,
                            ),
                            child: Row(
                              children: [
                                _buildShimmerBox(
                                  width: ScreenUtil.iconSizeSmall,
                                  height: ScreenUtil.iconSizeSmall,
                                  borderRadius: ScreenUtil.borderRadiusSmall,
                                ),
                                SizedBox(width: ScreenUtil.spacingMedium),
                                Expanded(
                                  child: _buildShimmerBox(
                                    height: ScreenUtil.textSizeMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Shimmer overlay
                  Positioned.fill(
                    child: Transform.translate(
                      offset: Offset(
                        _animation.value * MediaQuery.of(context).size.width,
                        0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.4),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerBox({
    double? width,
    required double height,
    double? borderRadius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: widget.baseColor,
        borderRadius: BorderRadius.circular(
          borderRadius ?? ScreenUtil.borderRadiusSmall,
        ),
      ),
    );
  }
}