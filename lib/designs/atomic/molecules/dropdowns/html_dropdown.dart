import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

class HtmlDropdown extends StatefulWidget {
  /// {@template html_dropdown}
  /// HtmlDropdown
  ///
  /// An atomic design molecule widget that displays a dropdown with a title and renders HTML content when expanded.
  ///
  /// This widget is designed for use in atomic design systems, serving as a "molecule" that combines basic atoms (text, icon, padding) with advanced HTML rendering.
  ///
  /// It supports design tokens for colors, spacing, and font styles, ensuring consistency and maintainability across your design system.
  ///
  /// Example usage:
  /// ```dart
  /// HtmlDropdown(
  ///   title: 'Details',
  ///   titleTextStyle: TextStyle(
  ///     fontWeight: FontWeight.bold,
  ///     fontSize: 18,
  ///   ),
  ///   htmlContent: '<p>This is <b>HTML</b> content.</p>',
  ///   arrowIcon: Icon(Icons.expand_more),
  ///   contentPadding: EdgeInsets.all(16),
  /// )
  /// ```
  /// {@endtemplate}
  const HtmlDropdown({
    super.key,
    required this.title,
    this.titleTextStyle,
    required this.htmlContent,
    this.arrowIcon,
    this.contentPadding,
    this.selectorPadding,
  });
  
  /// The HTML string to render when the dropdown is expanded.
  final String htmlContent;

  /// The title displayed in the dropdown header.
  final String title;

  /// Optional custom text style for the dropdown title. Defaults to a standard text style.
  final TextStyle? titleTextStyle;

  /// Optional custom icon for the dropdown arrow. Defaults to [Icons.chevron_right].
  final Widget? arrowIcon;

  /// Optional custom padding for the dropdown content. Defaults to design token spacing.
  final EdgeInsetsGeometry? contentPadding;

  ///
  final EdgeInsetsGeometry? selectorPadding;


  @override
  State<HtmlDropdown> createState() => _HtmlDropdownState();
}

class _HtmlDropdownState extends State<HtmlDropdown> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          contentPadding: widget.selectorPadding ?? 
            StoycoScreenSize.fromLTRB(
              context, 
              left: 24, 
              right: 24,
              leftPhone: 40,
              rightPhone: 24,
            ),
          focusColor: StoycoColors.transparent,
          splashColor: StoycoColors.transparent,
          title: Text(
            widget.title,
            style: widget.titleTextStyle ?? TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: StoycoScreenSize.fontSize(context, 16),
              fontFamily: 'Akkurat_Pro',
              color: StoycoColors.text,
            ),
          ),
          trailing: AnimatedRotation(
            turns: expanded ? 0.25 : 0,
            duration: const Duration(milliseconds: 200),
            child: widget.arrowIcon ?? StoycoAssets.lib.assets.icons.arrowRight.svg(),
          ),
          onTap: () => setState(() => expanded = !expanded),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: expanded
              ? SizedBox(
                  child: Padding(
                    padding: widget.contentPadding ?? StoycoScreenSize.fromLTRB(context, left: 16, right: 16),
                    child: SingleChildScrollView(
                      child: HtmlWidget(
                        widget.htmlContent,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
