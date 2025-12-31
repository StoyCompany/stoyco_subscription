import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/buttons/button_gradient_text.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// {@template custom_tab_bar}
/// A [CustomTabBar] molecule for the Stoyco Subscription Atomic Design System.
/// Renders a horizontally scrollable tab bar with custom styles, gradient text, and interactive selection.
///
/// ### Atomic Level
/// **Molecule** – Composed of multiple atoms (buttons, text) for tab navigation.
///
/// ### Parameters
/// - `width`: The total width of the tab bar. Defaults to 324.
/// - `height`: The height of the tab bar. Defaults to 40.
/// - `padding`: Padding around the tab bar. If null, uses design token spacing.
/// - `tabs`: List of tab labels to display.
/// - `onTabChanged`: Callback when a tab is selected, provides the tab index.
/// - `initialNavIndex`: The initially selected tab index.
/// - `isLoading`: If true, disables tab interaction.
///
/// ### Returns
/// Renders a custom tab bar with styled tab buttons, selection, and scroll behavior.
///
/// ### Example
/// ```dart
/// CustomTabBar(
///   tabs: ['Overview', 'Details', 'Settings'],
///   initialNavIndex: 0,
///   onTabChanged: (index) {},
/// )
/// ```
/// {@endtemplate}
class CustomTabBar extends StatefulWidget {
  /// {@macro custom_tab_bar}
  const CustomTabBar({
    super.key,
    this.width = 346,
    this.height = 33,
    this.padding,
    required this.tabs,
    required this.onTabChanged,
    required this.initialNavIndex,
    this.isLoading = false,
  });

  /// The total width of the tab bar. Defaults to 324.
  final double width;

  /// The height of the tab bar. Defaults to 40.
  final double height;

  /// Padding around the tab bar. If null, uses design token spacing.
  final EdgeInsetsGeometry? padding;

  /// List of tab labels to display.
  final List<String> tabs;

  /// Callback when a tab is selected, provides the tab index.
  final void Function(int index) onTabChanged;

  /// The initially selected tab index.
  final int initialNavIndex;

  /// If true, disables tab interaction.
  final bool isLoading;

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  int selectedIndex = 0;
  final List<GlobalKey> textKeys = <GlobalKey<State<StatefulWidget>>>[];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialNavIndex;
    textKeys.addAll(
      List<GlobalKey>.generate(widget.tabs.length, (_) => GlobalKey()),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void changeTab(int index) {
    if (selectedIndex == index || widget.isLoading) {
      return;
    }
    setState(() {
      selectedIndex = index;
    });
    widget.onTabChanged(index);
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double tabBarWidth = widget.tabs.length > 1 ? widget.width : widget.width / 2;
    
    return Container(
      height: StoycoScreenSize.height(context, widget.height),
      width: tabBarWidth,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: StoycoColors.menuItemBackground,
        borderRadius: BorderRadius.circular(
          StoycoScreenSize.radius(context, 106),
        ),
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(widget.tabs.length, (int index) {
            final bool isSelected = selectedIndex == index;
            return SizedBox(
              height: StoycoScreenSize.height(context, widget.height),
              width: tabBarWidth / widget.tabs.length,
              child: isSelected
                  ? Padding(
                    padding: widget.padding ?? StoycoScreenSize.symmetric(
                      context,
                      verticalPhone: 3,
                      vertical: 2,
                      horizontalPhone: 3,
                      horizontal: 2,
                    ),
                    child: ButtonGradientText(
                        text: widget.tabs[index],
                        onPressed: () => changeTab(index),
                        alignmentContent: Alignment.center,
                        paddingContent: widget.padding ?? StoycoScreenSize.symmetric(
                          context,
                          verticalPhone: 3,
                          vertical: 2,
                        ),
                        borderRadius: StoycoScreenSize.radius(context, 106),
                        type: ButtonGradientTextType.tertiary,
                        textStyle: TextStyle(
                          fontFamily: FontFamilyToken.akkuratPro,
                          color: StoycoColors.deepTeal,
                          fontSize: StoycoScreenSize.fontSize(
                            context,
                            18,
                            phone: 14,
                          ),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  )
                  : Padding(
                    padding: widget.padding ?? StoycoScreenSize.symmetric(
                      context,
                      verticalPhone: 3,
                      vertical: 2,
                      horizontalPhone: 3,
                      horizontal: 2,
                    ),
                    child: ButtonGradientText(
                        text: widget.tabs[index],
                        alignmentContent: Alignment.center,
                        textStyle: TextStyle(
                          fontFamily: FontFamilyToken.akkuratPro,
                          color: StoycoColors.iconDefault,
                          fontSize: StoycoScreenSize.fontSize(
                            context,
                            18,
                            phone: 14,
                          ),
                          fontWeight: FontWeight.w400,
                        ),
                        onPressed: () => changeTab(index),
                        paddingContent: StoycoScreenSize.symmetric(
                          context,
                          vertical: 2,
                          verticalPhone: 3,
                          horizontalPhone: 3,
                        ),
                        borderRadius: StoycoScreenSize.radius(context, 106),
                        type: ButtonGradientTextType.custom,
                        backgroundColor: StoycoColors.transparent,
                      ),
                  ),
            );
          }),
        ),
      ),
    );
  }
}
