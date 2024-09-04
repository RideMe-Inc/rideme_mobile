import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';

class SearchingForRiderAnimation extends StatefulWidget {
  final double circleOpacity;

  final Color baseColor, pulseColor;

  final String eta;

  const SearchingForRiderAnimation({
    super.key,
    this.baseColor = AppColors.rideMeBackgroundLight,
    this.pulseColor = AppColors.rideMeBackgroundLight,
    this.circleOpacity = 0.05,
    required this.eta,
  });

  @override
  State<SearchingForRiderAnimation> createState() =>
      _SearchingForRiderAnimationState();
}

class _SearchingForRiderAnimationState extends State<SearchingForRiderAnimation>
    with TickerProviderStateMixin {
  late AnimationController _outerCircle;
  late AnimationController _innerCircle;
  late AnimationController _pulseController;

  ///Restart pulse animation
  restartAnimation() async {
    //start pulse animation
    _pulseController.forward();

    //start outer circle scale
    _outerCircle.forward();

    //start inner circle animation to account for the delay
    await Future.delayed(
      const Duration(milliseconds: 200),
      () {
        _innerCircle.forward();
      },
    );

    //first stop for outer circle in the animation
    await Future.delayed(const Duration(milliseconds: 142), () {
      _outerCircle.stop();
    });

    /*
    continue outer circle animation and start inner circle pulse
    animation after 350ms to account for inner circle delay
    */
    await Future.delayed(
      const Duration(milliseconds: 350),
      () {
        _pulseController.forward();
        _outerCircle.forward();
      },
    );
  }

  disposeControllers() {
    //stop controllers
    _outerCircle.stop();
    _innerCircle.stop();
    _pulseController.stop();

    //dispose controllers
    _outerCircle.dispose();
    _innerCircle.dispose();
    _pulseController.dispose();
  }

  @override
  void initState() {
    _outerCircle = AnimationController(
      vsync: this,
    );

    _innerCircle = AnimationController(
      vsync: this,
    );

    _pulseController = AnimationController(
      vsync: this,
    );

    super.initState();
  }

  @override
  void dispose() {
    disposeControllers();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        //inner circle
        Container(
          height: Sizes.height(context, 0.13),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.pulseColor.withOpacity(widget.circleOpacity),
          ),
        )
            .animate(
              controller: _innerCircle,
              onPlay: (controller) async {
                /*
                continue outer circle animation and start inner circle pulse
                animation after 500ms to account for inner circle delay
                */

                await Future.delayed(
                  const Duration(milliseconds: 500),
                  () {
                    _outerCircle.forward();
                    _pulseController.forward();
                  },
                );
              },
            )
            .scale(
              curve: Curves.easeIn,
              delay: const Duration(milliseconds: 500),
              duration: const Duration(milliseconds: 300),
              begin: const Offset(0, 0),
              end: const Offset(1.14, 1.14),
            )
            .fadeIn(
              curve: Curves.easeIn,
              delay: const Duration(milliseconds: 400),
              duration: const Duration(milliseconds: 300),
            )
            .scale(
              curve: Curves.easeIn,
              delay: const Duration(milliseconds: 1000),
              duration: const Duration(milliseconds: 240),
              begin: const Offset(1.14, 1.14),
              end: const Offset(2, 2),
            )
            .fadeOut(
              delay: const Duration(milliseconds: 1000),
            ),

        //Outer circle
        Container(
          height: Sizes.height(context, 0.13),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.pulseColor.withOpacity(widget.circleOpacity),
          ),
        )
            .animate(
              controller: _outerCircle,
              onPlay: (controller) async {
                //stop the animation after 342ms

                await Future.delayed(
                  const Duration(milliseconds: 342),
                  () {
                    controller.stop();
                  },
                );
              },
              onComplete: (controller) async {
                // reset all controllers after 100ms
                await Future.delayed(
                  const Duration(milliseconds: 100),
                  () {
                    controller.reset();
                    _innerCircle.reset();
                    _pulseController.reset();
                  },
                );

                //restart animation
                await Future.delayed(
                  const Duration(milliseconds: 50),
                  restartAnimation,
                );
              },
            )
            .scale(
              duration: const Duration(milliseconds: 600),
              begin: const Offset(0, 0),
              end: const Offset(2, 2),
            )
            .fadeIn(
              // curve: Curves.easeIn,
              delay: const Duration(milliseconds: 100),
              duration: const Duration(milliseconds: 170),
            )
            .fadeOut(
              delay: const Duration(milliseconds: 850),
            ),

        //Pulse
        Container(
          height: Sizes.height(context, 0.13),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.pulseColor,
          ),
        )
            .animate(
              controller: _pulseController,
              onComplete: (controller) => controller.reset(),
            )
            .scale(
              duration: const Duration(milliseconds: 300),
              begin: const Offset(0.5, 0.5),
              end: const Offset(1.14, 1.14),
            )
            .fadeOut(
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 300),
            ),

        //base with image
        Container(
          height: Sizes.height(context, 0.07),
          padding: EdgeInsets.symmetric(
            horizontal: Sizes.width(context, 0.034),
            vertical: Sizes.height(context, 0.006),
          ),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.rideMeBlueNormal,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  widget.eta,
                  style: context.textTheme.displaySmall?.copyWith(
                    color: AppColors.rideMeBackgroundLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                'min',
                style: context.textTheme.displaySmall?.copyWith(
                  color: AppColors.rideMeBackgroundLight,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
