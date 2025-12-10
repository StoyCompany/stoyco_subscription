

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/buttons/button_gradient.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// Enum to control icon position in [ButtonGradientText].
enum ButtonGradientTextIconPosition { none, left, right }

enum ButtonGradientTextType { primary, secondary, tertiary, inactive, loading, custom }

/// {@template button_gradient_text}
/// A [ButtonGradientText] molecule for the Stoyco Subscription Atomic Design System.
/// Renders a customizable button with gradient borders, backgrounds, and multiple style variants.
///
/// ### Atomic Level
/// **Molecule** – Composed of atoms (gradient, text, shadow) for button interactions.
///
/// ### Parameters
/// - `textWidget`: The widget to display as button content. If provided, overrides [text].
/// - `text`: The label displayed inside the button.
/// - `type`: The button style variant, defined by [ButtonGradientTextType].
/// - `width`: The width of the button.
/// - `height`: The height of the button.
/// - `onPressed`: Callback executed when the button is tapped.
/// - `paddingButton`: Internal padding for the button.
/// - `paddingContent`: Internal padding for the button content.
/// - `textAlign`: Alignment for the button text.
/// - `textStyle`: Custom text style for the label.
/// - `borderWidth`: Width of the button border.
/// - `borderRadius`: Border radius for rounded corners.
/// - `boxShadow`: List of shadows applied to the button.
/// - `gradientBorder`: Custom gradient border for the button.
/// - `backgroundGradientColor`: Custom gradient for the background.
/// - `backgroundColor`: Solid background color (used if no gradient).
/// - `hoverColor`: Hover color for interactive states.
/// - `splashColor`: Splash color for interactive states.
/// - `focusColor`: Focus color for interactive states.
/// - `highlightColor`: Highlight color for interactive states.
/// - `iconWidget`: Optional icon widget to display in the button (left or right).
/// - `iconPosition`: Controls the icon position (none, left, right).
///
/// ### Returns
/// Renders a button with gradient border, background, and styled text, supporting multiple variants for atomic design systems.
///
/// ### Example
/// ```dart
/// ButtonGradientText(
///   text: 'Subscribe',
///   type: ButtonGradientTextType.primary,
///   onPressed: () {},
/// )
/// ```
/// {@endtemplate}

class ButtonGradientText extends StatelessWidget {
  /// Creates a [ButtonGradientText] molecule for the Stoyco Subscription Design System.
  ///
  /// - [textWidget]: The widget to display as button content. If provided, overrides [text].
  /// - [text]: The label displayed inside the button.
  /// - [type]: The button style variant, defined by [ButtonGradientTextType].
  /// - [width]: The width of the button.
  /// - [height]: The height of the button.
  /// - [onPressed]: Callback executed when the button is tapped.
  /// - [paddingButton]: Internal padding for the button.
  /// - [paddingContent]: Internal padding for the button content.
  /// - [textAlign]: Alignment for the button text.
  /// - [textStyle]: Custom text style for the label.
  /// - [borderWidth]: Width of the button border.
  /// - [borderRadius]: Border radius for rounded corners.
  /// - [boxShadow]: List of shadows applied to the button.
  /// - [gradientBorder]: Custom gradient border for the button.
  /// - [backgroundGradientColor]: Custom gradient for the background.
  /// - [backgroundColor]: Solid background color (used if no gradient).
  /// - [hoverColor]: Hover color for interactive states.
  /// - [splashColor]: Splash color for interactive states.
  /// - [focusColor]: Focus color for interactive states.
  /// - [highlightColor]: Highlight color for interactive states.
  /// - [iconWidget]: Optional icon widget to display in the button (left or right).
  /// - [iconPosition]: Controls the icon position (none, left, right).
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
    this.borderRadius = 100,
    this.boxShadow,
    this.gradientBorder,
    this.backgroundGradientColor, 
    this.backgroundColor,
    this.hoverColor,
    this.splashColor,
    this.focusColor,
    this.highlightColor,
    this.iconWidget,
    this.iconPosition = ButtonGradientTextIconPosition.none,
    this.alignmentContent,
  });
  /// Optional icon widget to display in the button (left or right).
  final Widget? iconWidget;

  /// Controls the icon position (none, left, right).
  final ButtonGradientTextIconPosition iconPosition;

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

  /// Internal padding for the button.
  final EdgeInsetsGeometry? paddingButton;
  
  /// Internal padding for the button content.
  final EdgeInsetsGeometry? paddingContent;

  /// Alignment for the button text.
  final TextAlign? textAlign;

  /// Custom text style for the label.
  final TextStyle? textStyle;

  /// Width of the button border.
  final double borderWidth;

  /// Border radius for rounded corners.
  final double borderRadius;

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

  /// Alignment for the content inside the button.
  final Alignment? alignmentContent;

  @override
  Widget build(BuildContext context) {
    BoxBorder? border;
    Gradient? backgroundG;
    Color? backgroundC;
    TextStyle? style;
    List<BoxShadow>? shadows;

    switch (type) {
      case ButtonGradientTextType.primary:
        backgroundC = StoycoColors.lightViolet;
        style = textStyle ?? TextStyle(
          color: StoycoColors.text,
          fontSize: StoycoScreenSize.fontSize(context, 16),
          fontWeight: FontWeight.w700,
          fontFamily: FontFamilyToken.akkuratPro,
        );
      case ButtonGradientTextType.secondary:
        border = Border.all(
          color: StoycoColors.lightViolet,
          width: borderWidth,
        );

        shadows = boxShadow;
        backgroundC = backgroundColor ?? StoycoColors.gray;

        style = textStyle ?? TextStyle(
          fontFamily: FontFamilyToken.akkuratPro,
          color: StoycoColors.text,
          fontSize: StoycoScreenSize.fontSize(context, 16),
          fontWeight: FontWeight.bold,
        );
      case ButtonGradientTextType.tertiary:
        backgroundC = backgroundColor ?? StoycoColors.text;

        style = textStyle ?? TextStyle(
          fontFamily: FontFamilyToken.akkuratPro,
          color: StoycoColors.deepTeal,
          fontSize: StoycoScreenSize.fontSize(context, 14),
          fontWeight: FontWeight.bold,
        );
      case ButtonGradientTextType.inactive || ButtonGradientTextType.loading:
        border = gradientBorder;
        shadows = boxShadow;
        backgroundC = backgroundColor ?? StoycoColors.hint;
        style = textStyle ?? TextStyle(
          fontFamily: FontFamilyToken.akkuratPro,
          color: StoycoColors.iconDefault,
          fontSize: StoycoScreenSize.fontSize(context, 16),
          fontWeight: FontWeight.bold,
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
      border: gradientBorder ?? border,
      hoverColor: hoverColor,
      splashColor: splashColor,
      focusColor: focusColor,
      highlightColor: highlightColor,
      alignmentContent: alignmentContent,
      onPressed: (type == ButtonGradientTextType.inactive || type == ButtonGradientTextType.loading) ? null : onPressed,
      child: Padding(
        padding: paddingContent ?? StoycoScreenSize.symmetric(context, horizontal: 24, vertical: 16),
        child: _buildContent(context, style),
      ),
    );

  }

  Widget _buildContent(BuildContext context, TextStyle? style) {
    if (type == ButtonGradientTextType.loading) {
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox(
            width: height ?? StoycoScreenSize.width(context, 24),
            height: height ?? StoycoScreenSize.width(context, 24),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(StoycoColors.white2),
            ),
          ),
        ],
      );
    }
    if (iconWidget == null || iconPosition == ButtonGradientTextIconPosition.none) {
      return textWidget ?? Text(
        text,
        textAlign: textAlign ?? TextAlign.center,
        maxLines: null,
        softWrap: true,
        style: style,
      );
    }
    if (iconPosition == ButtonGradientTextIconPosition.left) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          iconWidget!,
          Gap(StoycoScreenSize.width(context, 8)),
          const SizedBox(width: 8),
          textWidget ?? Text(
            text,
            textAlign: textAlign ?? TextAlign.center,
            maxLines: null,
            softWrap: true,
            style: style,
          ),
        ],
      );
    }
    if (iconPosition == ButtonGradientTextIconPosition.right) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          textWidget ?? Text(
            text,
            textAlign: textAlign ?? TextAlign.center,
            maxLines: null,
            softWrap: true,
            style: style,
          ),
          Gap(StoycoScreenSize.width(context, 8)),
          iconWidget!,
        ],
      );
    }
    return textWidget ?? Text(
      text,
      textAlign: textAlign ?? TextAlign.center,
      maxLines: null,
      softWrap: true,
      style: style,
    );
  }
}
