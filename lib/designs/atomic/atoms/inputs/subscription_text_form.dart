import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// {@template subscription_text_form}
/// A customizable [SubscriptionTextForm] atom for the Stoyco Subscription Design System.
/// Provides a styled text input field with label, hint, error display, and icon support.
///
/// ### Atomic Level
/// **Atom** – Smallest UI unit.
///
/// ### Parameters
/// - `labelText`: The label displayed above the input field.
/// - `labelTextStyle`: Custom style for the label text.
/// - `hintText`: Placeholder text shown when the field is empty.
/// - `hintStyle`: Custom style for the hint text.
/// - `controller`: Controls the text being edited.
/// - `focusNode`: Manages focus for the input field.
/// - `errorText`: Error message displayed below the field.
/// - `errorStyle`: Custom style for the error text.
/// - `errorMaxLines`: Maximum lines for error message (default: 3).
/// - `onChanged`: Callback when the text changes.
/// - `obscureText`: Whether to hide the input (e.g., for passwords).
/// - `obscuringCharacter`: Character used for obscuring text (default: '•').
/// - `keyboardType`: Keyboard type for input (default: text).
/// - `style`: Custom style for the input text.
/// - `suffixIcon`: Widget displayed at the end of the input field.
/// - `prefixIcon`: Widget displayed at the start of the input field.
///
/// ### Returns
/// Renders a [TextFormField] with custom label, hint, error, and icon styling, suitable for atomic usage in forms.
///
/// ### Example
/// ```dart
/// const SubscriptionTextForm(
///   labelText: 'Email',
///   hintText: 'Enter your email',
/// );
/// ```
/// {@endtemplate}

class SubscriptionTextForm extends StatelessWidget {
/// {@macro subscription_text_form}
  const SubscriptionTextForm({
    super.key,
    this.labelText,
    this.labelTextStyle,
    this.hintText,
    this.hintStyle,
    this.controller,
    this.focusNode,
    this.errorText,
    this.errorStyle,
    this.errorMaxLines = 3,
    this.onChanged,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.keyboardType = TextInputType.text,
    this.style,
    this.suffixIcon,
    this.prefixIcon,
  });

  /// The label displayed above the input field.
  final String? labelText;
  /// Custom style for the label text.
  final TextStyle? labelTextStyle;
  /// Placeholder text shown when the field is empty.
  final String? hintText;
  /// Custom style for the hint text.
  final TextStyle? hintStyle;
  /// Controls the text being edited.
  final TextEditingController? controller;
  /// Manages focus for the input field.
  final FocusNode? focusNode;
  /// Error message displayed below the field.
  final String? errorText;
  /// Custom style for the error text.
  final TextStyle? errorStyle;
  /// Maximum lines for error message. Defaults to 3.
  final int? errorMaxLines;
  /// Callback when the text changes.
  final ValueChanged<String>? onChanged;
  /// Whether to hide the input (e.g., for passwords).
  final bool obscureText;
  /// Character used for obscuring text. Defaults to '•'.
  final String obscuringCharacter;
  /// Keyboard type for input. Defaults to [TextInputType.text].
  final TextInputType keyboardType;
  /// Custom style for the input text.
  final TextStyle? style;
  /// Widget displayed at the end of the input field.
  final Widget? suffixIcon;
  /// Widget displayed at the start of the input field.
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscuringCharacter: obscuringCharacter,
      obscureText: obscureText,
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        errorText: errorText,
        errorStyle: errorStyle ?? TextStyle(
          color: StoycoColors.errorText,
          fontSize: StoycoScreenSize.fontSize(context, 12),
          fontFamily: FontFamilyToken.akkuratPro,
          fontWeight: FontWeight.w400,
          height: 1.2,
        ),
        errorMaxLines: errorMaxLines,
        label: Container(
          padding: StoycoScreenSize.symmetric(context, horizontal: 8, vertical: 3),
          decoration: (errorText != null && errorText!.isNotEmpty)
            ? null
            : ShapeDecoration(
              color: StoycoColors.midnightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(StoycoScreenSize.radius(context, 8)),
              ),
            ),
          child: Text(
            labelText ?? '',
            style: labelTextStyle ?? GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: (errorText != null && errorText!.isNotEmpty) ? StoycoColors.errorText : StoycoColors.hint, 
                fontSize: StoycoScreenSize.fontSize(context, 12),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(StoycoScreenSize.radius(context, 16)),
          borderSide: BorderSide(
            color: (errorText != null && errorText!.isNotEmpty) ? StoycoColors.errorText : StoycoColors.deepTeal, 
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(StoycoScreenSize.radius(context, 16)),
          borderSide: BorderSide(
            color: (errorText != null && errorText!.isNotEmpty) ? StoycoColors.errorText : StoycoColors.deepTeal,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(StoycoScreenSize.radius(context, 16)),
          borderSide: const BorderSide(
            color: StoycoColors.errorText,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(StoycoScreenSize.radius(context, 16)),
          borderSide: const BorderSide(
            color: StoycoColors.errorText,
            width: 1,
          ),
        ),
        hintText: hintText,
        hintStyle: hintStyle ?? GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: StoycoColors.hint,
              fontSize: StoycoScreenSize.fontSize(context, 14),
              fontWeight: FontWeight.w400,
          ),
        ),
      ),
      onChanged: onChanged,
      style: style ?? GoogleFonts.montserrat(
          textStyle: TextStyle(
          color: StoycoColors.text,
          fontSize: StoycoScreenSize.fontSize(context, 16),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
