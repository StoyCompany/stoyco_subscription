import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stoyco_subscription/atomic_design/design/screen_size.dart';
import 'package:stoyco_subscription/atomic_design/tokens/colors.dart';
import 'package:stoyco_subscription/core/gen/fonts.gen.dart';

/// {@template breadcrumbs}
/// A reusable breadcrumbs widget for navigation hierarchy.
///
/// Example:
/// ```dart
/// Breadcrumbs(
///   items: [
///     BreadcrumbItem(label: 'Home', onTap: () {}),
///     BreadcrumbItem(label: 'Subscriptions', onTap: () {}),
///     BreadcrumbItem(label: 'Music'),
///   ],
/// )
/// ```
/// {@endtemplate}
class Breadcrumbs extends StatelessWidget {
  /// The list of breadcrumb items.
  final List<BreadcrumbItem> items;

  /// The separator widget between items (default: Text('/')).
  final Widget Function(BuildContext context) separator;

  /// {@macro breadcrumbs}
  Breadcrumbs({
    super.key,
    required this.items,
    Widget Function(BuildContext context)? separator,
  }) : separator =
           separator ??
           ((BuildContext context) => Row(
             children: [
               SizedBox(width: StoycoScreenSize.width(context, 12)),
               Text(
                 '/',
                 style: GoogleFonts.inter(
                   textStyle: TextStyle(
                     fontWeight: FontWeight.w400,
                     fontSize: StoycoScreenSize.fontSize(context, 16),
                   ),
                 ),
               ),
               SizedBox(width: StoycoScreenSize.width(context, 12)),
             ],
           ));

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          GestureDetector(
            onTap: items[i].onTap,
            child: Text(
              items[i].label,
              style: i == 0
                  ? TextStyle(
                      color: StoycoColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: FontFamilyToken.akkuratPro,
                    )
                  : TextStyle(
                      color: StoycoColors.white,
                      fontWeight: FontWeight.w400,
                      fontFamily: FontFamilyToken.akkuratPro,
                    ),
            ),
          ),
          if (i < items.length - 1) separator(context),
        ],
      ],
    );
  }
}

/// Model for a breadcrumb item.
class BreadcrumbItem {
  /// The label to display.
  final String label;

  /// The callback when this breadcrumb is tapped (null for the last/current item).
  final VoidCallback? onTap;

  BreadcrumbItem({required this.label, this.onTap});
}
