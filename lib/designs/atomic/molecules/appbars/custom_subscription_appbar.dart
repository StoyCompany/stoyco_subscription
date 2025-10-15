import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// {@template custom_app_bar}
/// A customizable AppBar widget with an optional leading icon button, a centered title,
/// and an optional suffix icon button.
/// {@endtemplate}
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a [CustomAppBar].
  ///
  /// [title] is the centered title string.
  /// [leadingIcon] and [onLeadingPressed] are optional for the leading button.
  /// [suffixIcon] and [onSuffixPressed] are optional for the suffix button.
  const CustomAppBar({
    super.key,
    required this.title,
    this.leadingIcon,
    this.onLeadingPressed,
    this.suffixIcon,
    this.onSuffixPressed,
  });

  /// The icon widget for the leading button (optional).
  final Widget? leadingIcon;

  /// Callback for the leading button (optional).
  final VoidCallback? onLeadingPressed;

  /// The centered title string.
  final String title;

  /// The icon widget for the suffix button (optional).
  final Widget? suffixIcon;

  /// Callback for the suffix button (optional).
  final VoidCallback? onSuffixPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leadingIcon != null
          ? IconButton(onPressed: onLeadingPressed, icon: leadingIcon!)
          : null,
      title: Center(
        child: Text(
          title,
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: StoycoScreenSize.fontSize(context, 16),
            ),
          ),
        ),
      ),
      actions: [
        if (suffixIcon != null)
          IconButton(onPressed: onSuffixPressed, icon: suffixIcon!),
      ],
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
