import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AnimatedNextButton extends StatefulWidget {
  const AnimatedNextButton({
    super.key,
    required this.onNextPressed,
    required this.isLastPage,
  });

  final VoidCallback onNextPressed;
  final bool isLastPage;

  @override
  State<AnimatedNextButton> createState() => _AnimatedNextButtonState();
}

class _AnimatedNextButtonState extends State<AnimatedNextButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onNextPressed();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          height: 64,
          width: widget.isLastPage ? 180 : 160,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.isLastPage
                  ? [
                      AppColors.accentPurple,
                      AppColors.accentPurple.withValues(alpha: 0.8),
                    ]
                  : [AppColors.primaryDeepGreen, AppColors.brightGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color:
                    (widget.isLastPage
                            ? AppColors.accentPurple
                            : AppColors.primaryDeepGreen)
                        .withValues(alpha: 0.3),
                blurRadius: 12,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Text
              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                left: widget.isLastPage ? 20 : 24,
                child: Text(
                  widget.isLastPage ? "Get Started" : "Next",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              // Animated Icon Container
              AnimatedAlign(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                alignment: widget.isLastPage
                    ? Alignment.centerRight
                    : Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: AnimatedRotation(
                    duration: const Duration(milliseconds: 400),
                    turns: widget.isLastPage ? 0.125 : 0,
                    child: Icon(
                      widget.isLastPage
                          ? Icons.rocket_launch_rounded
                          : Icons.arrow_forward_rounded,
                      color: widget.isLastPage
                          ? AppColors.accentPurple
                          : AppColors.primaryDeepGreen,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
