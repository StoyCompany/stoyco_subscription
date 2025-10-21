import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/tab_bar/tab_bar_custom.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// {@template tab_menu_item}
/// A [TabMenuItem] molecule for the Book Stack Atomic Design System.
/// Renders a tabbed menu with description and child content, supporting tab navigation and page view.
///
/// ### Atomic Level
/// **Molecule** – Composed of atoms (tab bar, text, page view) for interactive menu navigation.
///
/// ### Parameters
/// - `tabs`: List of tab labels to display.
/// - `textDescription`: Optional description text below the tab bar.
/// - `textDescriptionStyle`: Custom text style for the description (optional).
/// - `children`: List of widgets to display for each tab (optional).
/// - `onTabChanged`: Callback when a tab is selected, provides the tab label.
/// - `initialNavIndex`: The initially selected tab index. Defaults to 0.
/// - `isLoading`: If true, disables tab interaction. Defaults to false.
///
/// ### Returns
/// Renders a tabbed menu with description and page view, suitable for atomic design systems.
///
/// ### Example
/// ```dart
/// TabMenuItem(
///   tabs: ['Tab 1', 'Tab 2'],
///   textDescription: 'Choose a tab',
///   children: [Widget1(), Widget2()],
///   onTabChanged: (tab) {},
/// )
/// ```
/// {@endtemplate}
class TabMenuItem extends StatefulWidget {
  /// {@macro tab_menu_item}
  const TabMenuItem({
    super.key, 
    required this.tabs, 
    this.textDescription,
    this.textDescriptionStyle,
    this.children,
    this.onTabChanged,
    this.initialNavIndex = 0,
    this.isLoading = false,
  });

  /// List of tab labels to display.
  final List<String> tabs;

  /// Optional description text below the tab bar.
  final String? textDescription;

  /// Custom text style for the description (optional).
  final TextStyle? textDescriptionStyle;

  /// List of widgets to display for each tab (optional).
  final List<Widget>? children;

  /// Callback when a tab is selected, provides the tab label.
  final void Function(String)? onTabChanged;

  /// The initially selected tab index. Defaults to 0.
  final int initialNavIndex;

  /// If true, disables tab interaction. Defaults to false.
  final bool isLoading;

  @override
  State<TabMenuItem> createState() => _TabMenuItemState();
}

class _TabMenuItemState extends State<TabMenuItem> {
  int selectedIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialNavIndex;
    _pageController = PageController(initialPage: selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onTabChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
    if (widget.onTabChanged != null) {
      widget.onTabChanged!(widget.tabs[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: StoycoScreenSize.symmetric(context, horizontal: 8, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: StoycoScreenSize.fromLTRB(context, bottom: 8.0),
            child: CustomTabBar(
              tabs: widget.tabs,
              initialNavIndex: widget.initialNavIndex,
              isLoading: widget.isLoading,
              onTabChanged: onTabChanged,
            ),
          ),
          if (widget.textDescription != null)
            Padding(
              padding: StoycoScreenSize.fromLTRB(context, bottom: 21.0, top: 13.0),
              child: Text(
                widget.textDescription!,
                textAlign: TextAlign.center,
                style: widget.textDescriptionStyle ?? TextStyle(
                  fontSize: StoycoScreenSize.fontSize(context, 16),
                  fontFamily: 'Akkurat_Pro',
                  fontWeight: FontWeight.bold,
                  color: StoycoColors.iconDefault,
                ),
              ),
            ),
          if (widget.children != null)
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (int index) {
                  setState(() {
                    selectedIndex = index;
                  });
                  if (widget.onTabChanged != null) {
                    widget.onTabChanged!(widget.tabs[index]);
                  }
                },
                children: widget.children ?? <Widget>[],
              ),
            ),
        ],
      ),
    );
  }
}
