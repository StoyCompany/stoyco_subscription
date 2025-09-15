import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/alert/alert_indicator.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// A widget that displays a text with an optional alert indicator.
///
/// The [TextWithAlert] widget is used to display a text with an optional alert indicator. It is commonly used in UI components where a title or message needs to be displayed along with an alert indicator to draw attention to it.
///
/// The [title] parameter is required and specifies the text to be displayed.
/// The [showAlertIndicator] parameter is required and determines whether the alert indicator should be shown or not.
/// The [animation] parameter is required and specifies the animation to be used for the alert indicator.
/// The [textWidth] parameter is required and specifies the width of the text.
///
/// Example usage:
///
/// ```dart
/// TextWithAlert(
///   title: 'Alert',
///   showAlertIndicator: true,
///   animation: animationController,
///   textWidth: 200,
/// )
/// ```
class TextWithAlert extends StatelessWidget {
  const TextWithAlert({
    super.key,
    required this.title,
    required this.showAlertIndicator,
    required this.animation,
    required this.textWidth,
  });

  final String title;
  final bool showAlertIndicator;
  final Animation<double> animation;
  final double textWidth;

  @override
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.center,
    children: <Widget>[
      Positioned(
        top: 6,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: StoycoScreenSize.fontSize(context, 20, phone: 14),
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      if (showAlertIndicator)
        AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) => Positioned(
            top: 0,
            left: StoycoScreenSize.width(context, textWidth + 5),
            child: AlertIndicator(animation: animation),
          ),
        ),
    ],
  );
}
