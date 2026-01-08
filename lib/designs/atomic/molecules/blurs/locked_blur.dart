import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/organisms/lock_subscription/basic_subs_card.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// {@template locked_blur}
/// A widget that applies a blur effect and overlay to indicate locked/premium content.
///
/// This widget wraps any child widget and applies a visual blur effect with
/// a semi-transparent overlay when content is locked. It includes a "locked"
/// badge and interactive hover effects to enhance user experience.
///
/// **Features:**
/// - Blur effect with customizable intensity
/// - Semi-transparent overlay with configurable color and opacity
/// - Interactive hover effect that increases blur and opacity
/// - Optional tap callback for locked content
/// - Customizable lock badge position
/// - Responsive design with border radius support
///
/// **Usage:**
/// ```dart
/// // Basic usage
/// LockedBlur(
///   isLocked: !userHasSubscription,
///   onTapElementExclusive: () => showUpgradeDialog(),
///   child: Image.network('premium_content.jpg'),
/// )
///
/// // Advanced customization
/// LockedBlur(
///   isLocked: true,
///   onTapElementExclusive: () => navigateToSubscription(),
///   child: VideoPlayer(controller: controller),
///   width: 300,
///   height: 200,
///   blurSigmaX: 5.0,
///   blurSigmaY: 5.0,
///   overlayColor: Colors.blue,
///   overlayOpacity: 0.4,
///   borderRadius: BorderRadius.circular(16),
///   alignment: Alignment.bottomRight,
/// )
/// ```
/// {@endtemplate}
class LockedBlur extends StatefulWidget {
  /// {@macro locked_blur}
  const LockedBlur({
    super.key,
    this.isLocked = true,
    this.onTapElementExclusive,
    required this.child,
    this.blurSigmaX = 2.5,
    this.blurSigmaY = 2.5,
    this.overlayColor = Colors.black,
    this.overlayOpacity = 0.3,
    this.radius = 0,
    this.borderRadius,
    this.alignment = Alignment.topRight,
    this.width,
    this.height = 144.0,
  });

  /// Whether the content is locked and should display the blur effect.
  ///
  /// When `true`, applies blur, overlay, and displays the lock badge.
  /// When `false`, displays the child widget without any effects.
  ///
  /// **Example:**
  /// ```dart
  /// isLocked: !userSubscription.isActive,
  /// ```
  final bool isLocked;

  /// Callback invoked when the locked content is tapped.
  ///
  /// Typically used to navigate to a subscription page or show an upgrade dialog.
  /// Only triggered when [isLocked] is `true`.
  ///
  /// **Example:**
  /// ```dart
  /// onTapElementExclusive: () {
  ///   showDialog(
  ///     context: context,
  ///     builder: (_) => SubscriptionRequiredDialog(),
  ///   );
  /// },
  /// ```
  final VoidCallback? onTapElementExclusive;

  /// The content widget to be displayed (with or without blur effect).
  final Widget child;

  /// Width of the widget. If null, takes available width.
  final double? width;

  /// Height of the widget. Defaults to 144.0.
  final double? height;

  /// Horizontal blur intensity (sigma X value for ImageFilter.blur).
  ///
  /// Higher values create more blur. Increases by 2.0 on hover.
  /// Defaults to 2.5.
  final double blurSigmaX;

  /// Vertical blur intensity (sigma Y value for ImageFilter.blur).
  ///
  /// Higher values create more blur. Increases by 2.0 on hover.
  /// Defaults to 2.5.
  final double blurSigmaY;

  /// Color of the semi-transparent overlay applied over the blurred content.
  ///
  /// Defaults to [Colors.black].
  final Color overlayColor;

  /// Opacity of the overlay (0.0 to 1.0).
  ///
  /// Increases by 0.15 on hover (clamped to 1.0).
  /// Defaults to 0.3.
  final double overlayOpacity;

  /// Corner radius value used when [borderRadius] is null.
  ///
  /// Applied using [StoycoScreenSize.radius] for responsive scaling.
  /// Defaults to 0.
  final double radius;

  /// Custom border radius for the blur and overlay effects.
  ///
  /// If null, uses [radius] to create a circular border radius.
  final BorderRadiusGeometry? borderRadius;

  /// Alignment position of the lock badge within the widget.
  ///
  /// Defaults to [Alignment.topRight].
  ///
  /// **Example:**
  /// ```dart
  /// alignment: Alignment.bottomLeft, // Lock badge at bottom-left
  /// ```
  final AlignmentGeometry alignment;

  @override
  State<LockedBlur> createState() => _LockedBlurState();
}

class _LockedBlurState extends State<LockedBlur> {
  /// Tracks whether the mouse is hovering over the widget.
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.isLocked ? widget.onTapElementExclusive : null,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              // Original content
              widget.child,

              // Blur and overlay effects (only when locked)
              if (widget.isLocked) ...<Widget>[
                ClipRRect(
                  borderRadius:
                      widget.borderRadius ??
                      BorderRadius.circular(
                        StoycoScreenSize.radius(context, widget.radius),
                      ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: widget.blurSigmaX + (_isHovered ? 2.0 : 0.0),
                      sigmaY: widget.blurSigmaY + (_isHovered ? 2.0 : 0.0),
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      color: widget.overlayColor.withOpacity(
                        _isHovered
                            ? (widget.overlayOpacity + 0.15).clamp(0.0, 1.0)
                            : widget.overlayOpacity,
                      ),
                    ),
                  ),
                ),
                // Lock badge
                Align(
                  alignment: widget.alignment,
                  child: SubscriptionLockedContent(
                    isLocked: widget.isLocked, 
                    child: SizedBox(
                      width: widget.width,
                      height: widget.height,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
