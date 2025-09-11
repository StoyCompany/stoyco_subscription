import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/tab_bar/tab_bar_custom.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

class TabMenuItem extends StatefulWidget {
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

  final List<String> tabs;
  final String? textDescription;
  final TextStyle? textDescriptionStyle;
  final List<Widget>? children;
  final void Function(String)? onTabChanged;
  final int initialNavIndex;
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
