import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// {@template subscription_search_bar}
/// A search bar widget for entering and filtering subscription queries.
///
/// This widget displays a styled [TextField] with a search icon and a customizable
/// [onChanged] callback. It can be controlled externally via a [TextEditingController].
///
/// Example usage:
/// ```dart
/// SubscriptionSearchBar(
///   controller: myController,
///   onChanged: (value) {
///     // Handle search input
///   },
/// )
/// ```
/// {@endtemplate}
class SubscriptionSearchBar extends StatefulWidget {
  /// {@macro subscription_search_bar}
  const SubscriptionSearchBar({super.key, this.controller, this.onChanged});

  /// Optional controller to manage the text being edited.
  final TextEditingController? controller;

  /// Called when the text in the search bar changes.
  final ValueChanged<String>? onChanged;

  @override
  State<SubscriptionSearchBar> createState() => _SubscriptionSearchBarState();
}

class _SubscriptionSearchBarState extends State<SubscriptionSearchBar> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF253341),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar...',
          hintStyle: TextStyle(
            color: StoycoColors.white,
            fontSize: StoycoScreenSize.fontSize(context, 14),
            fontFamily: FontFamilyToken.akkuratPro,
            fontWeight: FontWeight.w400,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: StoycoAssets.lib.assets.icons.catalog.searchNavbar.svg(
              package: 'stoyco_subscription',
              width: StoycoScreenSize.width(context, 16),
              height: StoycoScreenSize.height(context, 16),
            ),
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: StoycoScreenSize.width(context, 42),
            minHeight: StoycoScreenSize.height(context, 42),
            maxWidth: StoycoScreenSize.width(context, 42),
            maxHeight: StoycoScreenSize.height(context, 42),
          ),
          contentPadding: StoycoScreenSize.symmetric(
            context,
            horizontal: 16,
            vertical: 16,
          ),
        ),
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        onChanged: widget.onChanged,
      ),
    );
  }
}
