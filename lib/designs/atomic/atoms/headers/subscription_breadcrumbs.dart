import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

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
  /// {@macro breadcrumbs}
  Breadcrumbs({
    super.key,
    required this.items,
    Widget Function(BuildContext context)? separator,
  }) : separator =
           separator ??
           ((BuildContext context) => Row(
             children: <Widget>[
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

  /// The list of breadcrumb items.
  final List<BreadcrumbItem> items;

  /// The separator widget between items (default: Text('/')).
  final Widget Function(BuildContext context) separator;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        for (int i = 0; i < items.length; i++) ...<Widget>[
          GestureDetector(
            onTap: items[i].onTap,
            child: Text(
              items[i].label,
              style: i == 0
                  ? const TextStyle(
                      color: StoycoColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: FontFamilyToken.akkuratPro,
                    )
                  : const TextStyle(
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
  BreadcrumbItem({required this.label, this.onTap});

  /// The label to display.
  final String label;

  /// The callback when this breadcrumb is tapped (null for the last/current item).
  final VoidCallback? onTap;
}
