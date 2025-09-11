import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/alert/text_with_alert.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

class SubscriptionStoycoTab extends StatefulWidget {
  const SubscriptionStoycoTab({
    super.key,
    required this.title,
    this.showAlertIndicator = false,
  });

  final String title;
  final bool showAlertIndicator;

  @override
  SubscriptionStoycoTabState createState() => SubscriptionStoycoTabState();
}

class SubscriptionStoycoTabState extends State<SubscriptionStoycoTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: StoycoScreenSize.height(context, 26),
    child: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double textWidth = _calculateTextWidth(
          context,
          widget.title,
          constraints.maxWidth,
        );
        return TextWithAlert(
          title: widget.title,
          showAlertIndicator: widget.showAlertIndicator,
          animation: _animation,
          textWidth: textWidth,
        );
      },
    ),
  );

  double _calculateTextWidth(
    BuildContext context,
    String text,
    double maxWidth,
  ) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: StoycoScreenSize.fontSize(context, 14),
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '...',
    )..layout(maxWidth: maxWidth);
    return textPainter.size.width >= maxWidth
        ? maxWidth - StoycoScreenSize.width(context, 25)
        : textPainter.size.width;
  }
}
