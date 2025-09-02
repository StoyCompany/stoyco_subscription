import 'package:flutter/material.dart';
import 'package:stoyco_subscription/atomic_design/design/screen_size.dart';
import 'package:stoyco_subscription/atomic_design/tokens/colors.dart';
import 'package:stoyco_subscription/core/gen/fonts.gen.dart';

class SubscriptionSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  const SubscriptionSearchBar({super.key, this.controller, this.onChanged});

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
          prefixIcon: Icon(
            Icons.search,
            color: StoycoColors.white,
            size: StoycoScreenSize.fontSize(context, 16),
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
