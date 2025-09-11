import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/buttons/button_gradient_text.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({
    super.key,
    this.width = 324,
    this.height = 40,
    this.padding,
    required this.tabs,
    required this.onTabChanged,
    required this.initialNavIndex,
    this.isLoading = false,
  });

  final double width;
  final double height;
  final EdgeInsetsGeometry? padding;
  final List<String> tabs;
  final void Function(int index) onTabChanged;
  final int initialNavIndex;
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
    textKeys.addAll(List<GlobalKey>.generate(widget.tabs.length, (_) => GlobalKey()));
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
    return Container(
      height: StoycoScreenSize.height(context, widget.height),
      width: StoycoScreenSize.width(context, widget.width),
      padding: widget.padding ?? StoycoScreenSize.symmetric(context, horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: StoycoColors.menuItemBackground,
        borderRadius: BorderRadius.circular(106 - 1.06),
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          children: List<Widget>.generate(
            widget.tabs.length,
            (int index) {
              final bool isSelected = selectedIndex == index;
              return SizedBox(
                width: StoycoScreenSize.width(context, widget.width - StoycoScreenSize.symmetric(context, horizontal: 8).horizontal) / 2,
                child: isSelected 
                  ? ButtonGradientText(
                      text: widget.tabs[index], 
                      onPressed: () => changeTab(index),
                      paddingContent: StoycoScreenSize.symmetric(context, vertical: 2),
                      borderRadius: 106 - 1.06,
                      type: ButtonGradientTextType.tertiary,
                    )
                  : ButtonGradientText(
                      text: widget.tabs[index],
                      textStyle: TextStyle(
                        color: StoycoColors.iconDefault,
                        fontSize: StoycoScreenSize.fontSize(context, 14),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Montserrat',
                      ),
                      onPressed: () => changeTab(index),
                      paddingContent: StoycoScreenSize.symmetric(context, vertical: 2),
                      borderRadius: 106 - 1.06,
                      type: ButtonGradientTextType.custom,
                      backgroundColor: StoycoColors.transparent,
                    ),
              );
            },
          ),
        ),
      ),
    );
  }
}
