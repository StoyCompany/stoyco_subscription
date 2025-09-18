import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      width: StoycoScreenSize.width(context, widget.tabs.length > 1 ? widget.width : widget.width / 1.95),
      padding: widget.padding ?? StoycoScreenSize.symmetric(context, horizontal: 4),
      decoration: BoxDecoration(
        color: StoycoColors.menuItemBackground,
        borderRadius: BorderRadius.circular(StoycoScreenSize.radius(context, 105)),
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
                width: StoycoScreenSize.width(context, widget.width - StoycoScreenSize.symmetric(context, horizontal: 4).horizontal) / 2,
                child: isSelected 
                  ? ButtonGradientText(
                      text: widget.tabs[index], 
                      onPressed: () => changeTab(index),
                      paddingContent: StoycoScreenSize.symmetric(
                        context, 
                        verticalPhone: 6,
                        vertical: 2,
                      ),
                      borderRadius: StoycoScreenSize.radius(context, 105),
                      type: ButtonGradientTextType.tertiary,
                      textStyle: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: StoycoColors.deepCharcoal,
                          fontSize: StoycoScreenSize.fontSize(
                            context, 
                            18,
                            phone: 14,
                          ),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ButtonGradientText(
                      text: widget.tabs[index],
                      textStyle: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: StoycoColors.iconDefault,
                          fontSize: StoycoScreenSize.fontSize(
                            context, 
                            18,
                            phone: 14,
                          ),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onPressed: () => changeTab(index),
                      paddingContent: StoycoScreenSize.symmetric(
                          context, 
                          vertical: 2,
                          verticalPhone: 6,
                        ),
                      borderRadius: StoycoScreenSize.radius(context, 105),
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
