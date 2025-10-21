
import 'package:flutter/widgets.dart';

/// {@template hover_animation_card}
/// A hover-animated [HoverAnimationCard] atom for the Book Stack Atomic Design System.
/// Animates its child widget with a translation effect when hovered, providing interactive feedback for desktop and web platforms.
///
/// ### Atomic Level
/// **Atom** – Smallest UI unit.
///
/// ### Parameters
/// - `child`: The widget to animate on hover.
/// - `duration`: Animation duration for the hover effect. Defaults to 120 milliseconds.
/// - `curve`: Animation curve for the hover effect. Defaults to [Curves.easeInOut].
/// - `transformHoverX`: X offset for the hover transform. Defaults to 0.
/// - `transformHoverY`: Y offset for the hover transform. Defaults to -10.
/// - `transformHoverZ`: Z offset for the hover transform. Defaults to 0.
///
/// ### Returns
/// Renders an [AnimatedContainer] that animates its position when hovered, wrapping the provided child widget.
///
/// ### Example
/// ```dart
/// HoverAnimationCard(
///   child: Text('Hover me!'),
/// )
/// ```
/// {@endtemplate}
class HoverAnimationCard extends StatefulWidget {

  /// {@macro hover_animation_card}
  const HoverAnimationCard({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 120),
    this.curve = Curves.easeInOut,
    this.transformHoverX = 0,
    this.transformHoverY = -10,
    this.transformHoverZ = 0,
  });

  /// The widget to animate on hover.
  final Widget child;

  /// Animation duration for the hover effect. Defaults to 120 milliseconds.
  final Duration duration;

  /// Animation curve for the hover effect. Defaults to [Curves.easeInOut].
  final Curve curve;

  /// X offset for the hover transform. Defaults to 0.
  final double transformHoverX;

  /// Y offset for the hover transform. Defaults to -10.
  final double transformHoverY;

  /// Z offset for the hover transform. Defaults to 0.
  final double transformHoverZ;

  @override
  State<HoverAnimationCard> createState() => _HoverAnimationCardState();
}

class _HoverAnimationCardState extends State<HoverAnimationCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        curve: widget.curve,
        duration: widget.duration,
        transform: _isHovered
            ? Matrix4.translationValues(
                widget.transformHoverX,
                widget.transformHoverY,
                widget.transformHoverZ,
              )
            : Matrix4.identity(),
        child: widget.child,
      ),
    );
  }
}
