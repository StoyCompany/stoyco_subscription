import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/tags/tag_locked.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

class LockedBlur extends StatefulWidget {
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

  final bool isLocked;
  final VoidCallback? onTapElementExclusive;
  final Widget child;
  final double? width;
  final double? height;
  final double blurSigmaX;
  final double blurSigmaY;
  final Color overlayColor;
  final double overlayOpacity;
  final double radius;
  final BorderRadiusGeometry? borderRadius;
  final AlignmentGeometry alignment;

  @override
  State<LockedBlur> createState() => _LockedBlurState();
}

class _LockedBlurState extends State<LockedBlur> {
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
              widget.child,
              if (widget.isLocked) ...<Widget>[
                ClipRRect(
                  borderRadius: widget.borderRadius ??
                      BorderRadius.circular(
                          StoycoScreenSize.radius(context, widget.radius)),
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
                Align(
                  alignment: widget.alignment,
                  child: const TagLocked(isLocked: true),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}