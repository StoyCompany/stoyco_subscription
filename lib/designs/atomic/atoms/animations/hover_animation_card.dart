
import 'package:flutter/widgets.dart';

class HoverAnimationCard extends StatefulWidget {
/// Atomic Design System: Hover Animation Card
///
/// This widget is part of an atomic design system for Flutter, providing a reusable hover animation effect for cards and containers.
///
/// - Follows atomic design principles for scalability and maintainability.
/// - All documentation is provided inside the class for global visibility, as recommended by Flutter standards.
/// - Animates its child upwards when hovered (web/desktop only), using a fast and smooth transform.
/// - Can be used to wrap any card or container to provide a native-like hover effect.
///
/// Example usage:
/// ```dart
/// HoverAnimationCard(
///   child: CardImageDescriptionTag(...),
/// )
/// ```
///
/// Native Flutter alternative (for comparison):
/// ```dart
/// MouseRegion(
///   onEnter: (_) => setState(() => isHovered = true),
///   onExit: (_) => setState(() => isHovered = false),
///   child: AnimatedContainer(
///     duration: Duration(milliseconds: 120),
///     transform: isHovered
///         ? Matrix4.translationValues(0, -18, 0)
///         : Matrix4.identity(),
///     child: ...,
///   ),
/// )
/// ```
///
/// This component is designed for web/desktop platforms and will not trigger hover on mobile devices.

  /// Creates a [HoverAnimationCard] for atomic design systems.
  ///
  /// [child]: The widget to animate on hover.
  /// [duration]: Animation duration (default: 120ms).
  /// [curve]: Animation curve (default: easeInOut).
  /// [transformHoverX]: X offset for hover (default: 0).
  /// [transformHoverY]: Y offset for hover (default: -10).
  /// [transformHoverZ]: Z offset for hover (default: 0).
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
  /// Animation duration for the hover effect.
  final Duration duration;
  /// Animation curve for the hover effect.
  final Curve curve;
  /// X offset for the hover transform.
  final double transformHoverX;
  /// Y offset for the hover transform.
  final double transformHoverY;
  /// Z offset for the hover transform.
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
