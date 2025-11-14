import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/designs/utils/styles/gradient_border.dart';

/// A customizable dialog container widget with glassmorphism effect.
///
/// This widget creates a modal dialog with a translucent background and gradient borders.
/// It can be configured to close when tapping outside the dialog area.
/// Now supports a custom [gradientShadow] for the dialog container.
class DialogContainer extends StatelessWidget {
  /// Creates a [DialogContainer].
  ///
  /// * [children] - The list of widgets to display in the dialog content.
  /// * [padding] - The padding around the dialog content. Defaults to EdgeInsets.all(15.0).
  /// * [canClose] - Whether the dialog can be closed by tapping outside. Defaults to false.
  /// * [backgroundColor] - The background color of the dialog container.
  /// * [gradient] - The gradient to apply to the dialog container background.
  /// * [containerWidth] - The width of the dialog container. Defaults to 90% of screen width.
  /// * [gradientShadow] - The custom boxShadow to apply to the dialog container.
  const DialogContainer({
    super.key,
    this.padding,
    this.gradient,
    this.containerWidth,
    this.backgroundColor,
    this.canClose = false,
    this.gradientShadow,
    required this.children,
  });

  /// The widgets to display in the dialog content.
  final List<Widget> children;

  /// The padding around the dialog content.
  final EdgeInsetsGeometry? padding;

  /// Whether the dialog can be closed by tapping outside.
  final bool canClose;

  /// The background color of the dialog container.
  final Color? backgroundColor;

  /// The gradient to apply to the dialog container background.
  final Gradient? gradient;

  /// The width of the dialog container.
  final double? containerWidth;

  /// The custom boxShadow to apply to the dialog container.
  final List<BoxShadow>? gradientShadow;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.transparent,
    body: GestureDetector(
      onTap: () => canClose ? Navigator.of(context).pop() : null,
      child: GlassmorphicContainer(
        width: double.infinity,
        height: double.infinity,
        borderRadius: 0,
        blur: 10,
        border: 0,
        linearGradient: LinearGradient(
          colors: <Color>[
            const Color(0xFF030A1A).withAlpha(25),
            const Color(0xFF0C1B24).withAlpha(1),
          ],
          stops: const <double>[0.1, 1],
        ),
        borderGradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Color(0xFF030A1A), Color(0xFF0C1B24)],
          stops: <double>[10, 0],
        ),
        child: Center(
          child: GestureDetector(
            onTap: () {
              // Prevents propagation of the tap event to the parent GestureDetector
              // This allows the dialog to remain open when tapping inside the Center widget
            },
            child: Container(
              width: containerWidth ?? MediaQuery.of(context).size.width * 0.9,
              constraints: BoxConstraints(
                maxWidth: StoycoScreenSize.width(context, 500),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  StoycoScreenSize.radius(context, 25),
                ),
                color:
                    backgroundColor ??
                    (gradient == null
                        ? const Color.fromARGB(7, 238, 232, 232)
                        : null),
                gradient: gradient,
                boxShadow: gradientShadow,
              ),
              child: CustomPaint(
                painter: GradientBorder(
                  strokeWidth: StoycoScreenSize.width(context, 2.5),
                  radius: StoycoScreenSize.radius(context, 25),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color.fromARGB(42, 99, 97, 153),
                      Color.fromARGB(106, 99, 97, 153),
                      Color(0xFF636199),
                      Color.fromARGB(196, 88, 80, 200),
                      Color(0xFF4639E7),
                    ],
                  ),
                ),
                child: Padding(
                  padding: padding ?? StoycoScreenSize.all(context, 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
