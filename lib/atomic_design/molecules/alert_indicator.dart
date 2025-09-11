import 'package:flutter/material.dart';
import 'package:stoyco_subscription/atomic_design/design/screen_size.dart';

/// A widget that displays an alert indicator with animation.
class AlertIndicator extends StatelessWidget {
  /// Constructs an [AlertIndicator] widget.
  ///
  /// The [animation] parameter is required and specifies the animation for the alert indicator.
  const AlertIndicator({super.key, required this.animation});

  /// The animation for the alert indicator.
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) => Transform.scale(
    scale: animation.value,
    child: Container(
      height: StoycoScreenSize.height(context, 10),
      width: StoycoScreenSize.height(context, 10),
      decoration: BoxDecoration(
        color: const Color(0xffED0095),
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: const Color(0xffED0095).withOpacity(0.25),
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
    ),
  );
}
