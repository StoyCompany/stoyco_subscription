import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/buttons/button_gradient.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

enum ButtonGradientTextType { primary, secondary, tertiary, inactive, custom }

class ButtonGradientText extends StatelessWidget {
/// Atomic Design System: Gradient Text Button
///
/// This widget is part of an atomic design system for Flutter, providing a highly customizable button with gradient borders and backgrounds.
///
/// - Follows atomic design principles for scalability and maintainability.
/// - All documentation is provided inside the class for global visibility, as recommended by Flutter standards.
/// - Supports multiple button types via the [ButtonGradientTextType] enum: primary, secondary, tertiary, inactive, custom.
/// - Uses design tokens for colors and gradients, ensuring consistency across the app.
///
/// Example usage:
/// ```dart
/// ButtonGradientText(
///   text: 'Subscribe',
///   type: ButtonGradientTextType.primary,
///   onPressed: () {},
/// )
/// ```
///
/// [ButtonGradientTextType.primary]: Main action button with gradient border, background, and shadow.
/// [ButtonGradientTextType.secondary]: Secondary action button with radial gradient background and gradient border.
/// [ButtonGradientTextType.tertiary]: Tertiary button with solid background and no shadow.
/// [ButtonGradientTextType.inactive]: Disabled/inactive button style.
/// [ButtonGradientTextType.custom]: Fully custom style via parameters.
  const ButtonGradientText({
    super.key,
    this.textWidget,
    this.text = 'Example',
    required this.type,
    this.width,
    this.height,
    required this.onPressed,
    this.paddingButton,
    this.paddingContent,
    this.textAlign,
    this.textStyle,
    this.borderWidth = 1,
    this.borderRadius = 16,
    this.boxShadow,
    this.gradientBorder,
    this.backgroundGradientColor, 
    this.backgroundColor,
    this.hoverColor,
    this.splashColor,
    this.focusColor,
    this.highlightColor,
  });

  /// The widget to display as button content. If provided, overrides [text].
  final Widget? textWidget;

  /// The label displayed inside the button.
  final String text;

  /// The button style variant, defined by [ButtonGradientTextType].
  final ButtonGradientTextType type;

  /// The width of the button.
  final double? width;

  /// The height of the button.
  final double? height;

  /// Callback executed when the button is tapped.
  final VoidCallback? onPressed;

  /// Internal padding for the button
  final EdgeInsetsGeometry? paddingButton;
  
  /// Internal padding for the button content.
  final EdgeInsetsGeometry? paddingContent;

  /// Alignment for the button text.
  final TextAlign? textAlign;

  /// Custom text style for the label.
  final TextStyle? textStyle;

  /// Width of the button border.
  final double? borderWidth;

  /// Border radius for rounded corners.
  final double? borderRadius;

  /// List of shadows applied to the button.
  final List<BoxShadow>? boxShadow;

  /// Custom gradient border for the button.
  final GradientBoxBorder? gradientBorder;

  /// Custom gradient for the background.
  final Gradient? backgroundGradientColor;

  /// Solid background color (used if no gradient).
  final Color? backgroundColor;

  /// Hover color for interactive states.
  final Color? hoverColor;

  /// Splash color for interactive states.
  final Color? splashColor;

  /// Focus color for interactive states.
  final Color? focusColor;

  /// Highlight color for interactive states.
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    GradientBoxBorder? border;
    Gradient? backgroundG;
    Color? backgroundC;
    TextStyle? style;
    List<BoxShadow>? shadows;

    switch (type) {
      case ButtonGradientTextType.primary:
        border = gradientBorder ?? GradientBoxBorder(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: <double>[0.0751, 0.5643, 0.6543],
            colors: <Color>[
              StoycoColors.buttonBorderWhite25,
              StoycoColors.buttonBorderBlack25,
              StoycoColors.buttonBorderBlack25,
            ],
          ),
          width: borderWidth ?? 1,
        );

        shadows = boxShadow ?? const <BoxShadow>[
          BoxShadow(
            color: StoycoColors.buttonShadowDark,
            offset: Offset(0, 20),
            blurRadius: 30,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: StoycoColors.buttonShadowBlue50,
            offset: Offset(0, -20),
            blurRadius: 30,
            spreadRadius: 0,
          ),
        ];
        backgroundG = backgroundGradientColor ?? const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            StoycoColors.darkBlue,
            StoycoColors.blue,
          ],
        );
        style = textStyle ?? GoogleFonts.montserrat( 
          textStyle: TextStyle(
          color: StoycoColors.text,
          fontSize: StoycoScreenSize.fontSize(context, 16),
          fontWeight: FontWeight.w700,
        ));
      case ButtonGradientTextType.secondary:

        border = gradientBorder ?? GradientBoxBorder(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              StoycoColors.darkBlue,
              StoycoColors.blue,
            ],
          ),
          width: borderWidth ?? 1,
        );

        shadows = boxShadow;
        backgroundG = backgroundGradientColor ?? const RadialGradient(
          center: Alignment(-0.85, -0.92),
          radius: 0.964,
          colors: <Color>[
            StoycoColors.buttonSecondaryBgStart,
            StoycoColors.buttonSecondaryBgStart,
            StoycoColors.buttonSecondaryBgEnd,
          ],
          stops: <double>[0.0, 0.0001, 1.0],
        );

        style = textStyle ?? GoogleFonts.montserrat(
          textStyle: TextStyle(
            color: StoycoColors.text,
            fontSize: StoycoScreenSize.fontSize(context, 16),
            fontWeight: FontWeight.bold,
          ),
        );
      case ButtonGradientTextType.tertiary:
        border = gradientBorder ?? GradientBoxBorder(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              StoycoColors.darkBlue,
              StoycoColors.blue,
            ],
          ),
          width: borderWidth ?? 1,
        );

        shadows = boxShadow ?? const <BoxShadow>[
          BoxShadow(
            color: StoycoColors.shadowBlue,
            offset: Offset.zero,
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ];

        backgroundC = backgroundColor ?? StoycoColors.text;

        style = textStyle ?? GoogleFonts.montserrat(
          textStyle: TextStyle(
            color: StoycoColors.deepCharcoal,
            fontSize: StoycoScreenSize.fontSize(context, 14),
            fontWeight: FontWeight.bold,
          ),
        );
      case ButtonGradientTextType.inactive:
        border = gradientBorder;
        shadows = boxShadow;
        backgroundC = backgroundColor ?? StoycoColors.hint;
        style = textStyle ?? GoogleFonts.montserrat(
          textStyle: TextStyle(
            color: StoycoColors.iconDefault,
            fontSize: StoycoScreenSize.fontSize(context, 16),
            fontWeight: FontWeight.bold,
          ),
        );
      case ButtonGradientTextType.custom:
        border = gradientBorder;
        backgroundG = backgroundGradientColor;
        shadows = boxShadow;
        backgroundC = backgroundG != null ? null : backgroundColor;
        style = textStyle;
    }

    return ButtonGradient(
      width: width,
      height: height,
      padding: paddingButton,
      borderRadius: borderRadius,
      boxShadow: shadows,
      backgroundGradientColor: backgroundG,
      backgroundColor: backgroundC,
      gradientBorder: border,
      hoverColor: hoverColor,
      splashColor: splashColor,
      focusColor: focusColor,
      highlightColor: highlightColor,
      onPressed: type == ButtonGradientTextType.inactive ? null : onPressed,
      child: Padding(
        padding: paddingContent ?? StoycoScreenSize.symmetric(context, horizontal: 24, vertical: 16),
        child: textWidget ?? Text(
          text,
          textAlign: textAlign ?? TextAlign.center,
          maxLines: null,
          softWrap: true,
          style: style,
        ),
      ),
    );
  }
}
