import 'package:flutter/material.dart';
/// {@template custom_checkbox_row}
/// A customizable checkbox row atom for the Stoyco Subscription Atomic Design System.
/// Displays a checkbox with a label or custom widget, supporting tap interactions and custom background color.
///
/// ### Atomic Level
/// **Atom** – Smallest UI unit.
///
/// ### Parameters
/// - `value`: Whether the checkbox is checked.
/// - `onChanged`: Callback when the checkbox is toggled.
/// - `label`: The text label for the checkbox.
/// - `labelWidget`: Optional custom widget for the label.
/// - `onTapLabel`: Optional callback when the label is tapped (for navigation).
/// - `backgroundColor`: The background color of the checked checkbox. Defaults to [StoycoColors.royalIndigo].
///
/// ### Returns
/// Renders a [Row] containing a tappable checkbox and a label or widget, suitable for forms and settings.
///
/// ### Example
/// ```dart
/// CustomCheckboxRow(
///   value: true,
///   onChanged: (checked) {},
///   label: 'Accept Terms',
/// )
/// ```
/// {@endtemplate}
import 'package:gap/gap.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// {@macro custom_checkbox_row}
class CustomCheckboxRow extends StatelessWidget {
  /// Creates a [CustomCheckboxRow] atom for the Stoyco Subscription Design System.
  ///
  /// - [value]: Whether the checkbox is checked.
  /// - [onChanged]: Callback when the checkbox is toggled.
  /// - [label]: The text label for the checkbox.
  /// - [labelWidget]: Optional custom widget for the label.
  /// - [onTapLabel]: Optional callback when the label is tapped.
  /// - [backgroundColor]: The background color of the checked checkbox.
  const CustomCheckboxRow({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = '',
    this.labelWidget,
    this.onTapLabel,
    this.backgroundColor = StoycoColors.royalIndigo,
  });

  /// Whether the checkbox is checked.
  final bool value;

  /// Called when the checkbox is toggled.
  final ValueChanged<bool?> onChanged;

  /// The text label displayed next to the checkbox.
  final String label;

  /// Optional custom widget to display as the label instead of text.
  final Widget? labelWidget;

  /// The background color of the checked checkbox. Defaults to [StoycoColors.royalIndigo].
  final Color backgroundColor;

  /// Optional callback when the label is tapped (for navigation or actions).
  final VoidCallback? onTapLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () => onChanged(!value),
          child: Container(
            width: StoycoScreenSize.width(context, 24),
            height: StoycoScreenSize.width(context, 24),
            decoration: BoxDecoration(
              color: value ? backgroundColor : Colors.transparent,
              border: Border.all(
                color: value ? backgroundColor : StoycoColors.softWhite,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(
                StoycoScreenSize.radius(context, 8),
              ),
            ),
            child: value
                ? Padding(
                    padding: StoycoScreenSize.all(context, 4),
                    child: StoycoAssets.lib.assets.icons.common.checkBox.svg(
                      package: 'stoyco_subscription',
                      fit: BoxFit.contain,
                      width: StoycoScreenSize.width(context, 16),
                      height: StoycoScreenSize.width(context, 16),
                    ),
                  )
                : null,
          ),
        ),
        Gap(StoycoScreenSize.width(context, 12)),
        Expanded(
          child: InkWell(
            onTap: onTapLabel,
            child: labelWidget ?? Text(
              label,
              style: TextStyle(
                color: StoycoColors.text,
                fontSize: StoycoScreenSize.fontSize(context, 14),
                fontWeight: FontWeight.w500,
                fontFamily: FontFamilyToken.akkuratPro,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
