import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/images/image_network_blur.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/tags/tag_locked.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// {@template card_product_exclusive_locked}
/// A [CardProductExclusiveLocked] organism for the Stoyco Subscription Atomic Design System.
/// Renders a product card with image, name, category, and locked overlay for exclusive content.
///
/// ### Atomic Level
/// **Organism** – Composed of molecules and atoms (image, tag, overlay) for product display and interaction.
///
/// ### Parameters
/// - `imageUrl`: The main image URL for the product card.
/// - `imagePlaceholder`: Widget to show while the image is loading (optional).
/// - `imageError`: Widget to show if the image fails to load (optional).
/// - `name`: The product name to display.
/// - `category`: The product category to display.
/// - `isLocked`: If true, displays locked overlay and disables normal tap.
/// - `onTapProduct`: Callback when the unlocked product card is tapped.
/// - `onTapProductExclusive`: Callback when the locked product card is tapped.
/// - `heightCard`: Height of the card. Defaults to 160.
/// - `widthCard`: Width of the card. Defaults to 160.
/// - `borderRadiusCard`: Border radius for the card. Defaults to 8.
/// - `backgroundColorCard`: Background color for the card. Defaults to [StoycoColors.deepTeal].
/// - `paddingContentCard`: Padding for the content inside the card (optional).
/// - `nameFontStyle`: Custom text style for the product name (optional).
/// - `categoryFontStyle`: Custom text style for the category (optional).
///
/// ### Returns
/// Renders a product card with image, name, category, and locked overlay, suitable for atomic design systems.
///
/// ### Example
/// ```dart
/// CardProductExclusiveLocked(
///   imageUrl: 'https://example.com/image.jpg',
///   name: 'Exclusive Item',
///   category: 'Premium',
///   isLocked: true,
///   onTapProductExclusive: () {},
/// )
/// ```
/// {@endtemplate}
/// {@template event_card_exclusive_locked}
/// An [EventCardExclusiveLocked] organism for the Stoyco Subscription Atomic Design System.
///
/// ### Overview
/// Displays an event card with image, name, date, and lock status. Shows a locked overlay for exclusive or finished events, and provides tap callbacks for both locked and unlocked states. Highly customizable for use in event listings or exclusive content sections.
///
/// ### Atomic Level
/// **Organism** – Composed of atoms and molecules (image, tag, overlay) for event display and interaction.
///
/// ### Parameters
/// - `imageUrl`: The main image URL for the event card.
/// - `name`: The event name to display.
/// - `date`: The event date to display.
/// - `isLocked`: If true, displays locked overlay and disables normal tap. Defaults to true.
/// - `isFinished`: If true, shows a finished label and disables normal tap.
/// - `onTapEvent`: Callback when the unlocked event card is tapped.
/// - `onTapEventExclusive`: Callback when the locked event card is tapped.
/// - `imagePlaceholder`: Widget to show while the image is loading (optional).
/// - `imageError`: Widget to show if the image fails to load (optional).
/// - `heightCard`: Height of the card. Defaults to 200.
/// - `widthCard`: Width of the card. Defaults to 200.
/// - `borderRadiusCard`: Border radius for the card. Defaults to 16.
/// - `backgroundColorCard`: Background color for the card. Defaults to [StoycoColors.white2].
/// - `paddingContentCard`: Padding for the content inside the card (optional).
/// - `nameFontStyle`: Custom text style for the event name (optional).
/// - `dateFontStyle`: Custom text style for the event date (optional).
/// - `key`: Optional widget key.
///
/// ### Returns
/// Renders a visually rich event card with image, lock overlay, finished label, and event details, suitable for atomic design systems.
///
/// ### Example
/// ```dart
/// EventCardExclusiveLocked(
///   imageUrl: 'https://example.com/event.jpg',
///   name: 'Exclusive Event',
///   date: 'Oct 21, 2025',
///   isLocked: true,
///   isFinished: false,
///   onTapEventExclusive: () {},
/// )
/// ```
/// {@endtemplate}
class EventCardExclusiveLocked extends StatefulWidget {
  /// {@macro event_card_exclusive_locked}
  const EventCardExclusiveLocked({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.date,
    required this.isFinished,
    this.isLocked = true,
    this.imagePlaceholder,
    this.imageError,
    this.onTapEvent,
    this.onTapEventExclusive,
    this.heightCard = 200,
    this.widthCard = 200,
    this.borderRadiusCard = 16,
    this.backgroundColorCard = StoycoColors.white2,
    this.paddingContentCard,
    this.nameFontStyle,
    this.dateFontStyle,
  });

  /// The main image URL for the event card.
  final String imageUrl;

  /// The event name to display.
  final String name;

  /// The event date to display.
  final String date;

  /// If true, displays locked overlay and disables normal tap. Defaults to true.
  final bool isLocked;

  /// If true, shows a finished label and disables normal tap.
  final bool isFinished;

  /// Callback when the unlocked event card is tapped.
  final VoidCallback? onTapEvent;

  /// Callback when the locked event card is tapped.
  final VoidCallback? onTapEventExclusive;

  /// Widget to show while the image is loading (optional).
  final Widget? imagePlaceholder;

  /// Widget to show if the image fails to load (optional).
  final Widget? imageError;

  /// Height of the card. Defaults to 200.
  final double heightCard;

  /// Width of the card. Defaults to 200.
  final double widthCard;

  /// Border radius for the card. Defaults to 16.
  final double borderRadiusCard;

  /// Background color for the card. Defaults to [StoycoColors.white2].
  final Color backgroundColorCard;

  /// Padding for the content inside the card (optional).
  final EdgeInsetsGeometry? paddingContentCard;

  /// Custom text style for the event name (optional).
  final TextStyle? nameFontStyle;

  /// Custom text style for the event date (optional).
  final TextStyle? dateFontStyle;

  @override
  State<EventCardExclusiveLocked> createState() =>
      _EventCardExclusiveLockedState();
}

class _EventCardExclusiveLockedState extends State<EventCardExclusiveLocked> {
  bool _isInfoHovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => _isInfoHovered = true),
    onExit: (_) => setState(() => _isInfoHovered = false),
    child: InkWell(
      borderRadius: BorderRadius.circular(
        StoycoScreenSize.radius(context, widget.borderRadiusCard),
      ),
      onTap: (!widget.isFinished && widget.isLocked)
          ? widget.onTapEventExclusive
          : widget.onTapEvent,
      child: SizedBox(
        width: StoycoScreenSize.width(context, widget.widthCard),
        height: StoycoScreenSize.height(context, widget.heightCard),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) => Stack(
            children: <Widget>[
              Positioned(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      StoycoScreenSize.radius(context, 35),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: StoycoScreenSize.radius(context, 2),
                        blurRadius: StoycoScreenSize.radius(context, 10),
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: <Widget>[
                      ImageNetworkBlur(
                        height: constraints.maxHeight,
                        width: double.infinity,
                        radius: StoycoScreenSize.radius(context, 15),
                        imageUrl: widget.imageUrl,
                        isBlur: !widget.isFinished && widget.isLocked,
                        alignment: Alignment.topCenter,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: TagLocked(
                          isLocked: !widget.isFinished && widget.isLocked,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: widget.isFinished,
                child: Positioned(
                  top: 5,
                  right: 5,
                  child: SizedBox(
                    width: constraints.maxWidth * 0.5,
                    height: constraints.maxHeight * 0.11,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomRight,
                          stops: <double>[0, 1],
                          colors: <Color>[Color(0xff7F0065), Color(0xffED0095)],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                      ),
                      child: Container(
                        padding: StoycoScreenSize.all(context, 2),
                        child: SizedBox(
                          width: constraints.maxWidth * 0.11,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              'Finalizado',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: StoycoScreenSize.fontSize(
                                  context,
                                  13,
                                ),
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(
                      StoycoScreenSize.radius(context, 15),
                    ),
                    bottomRight: Radius.circular(
                      StoycoScreenSize.radius(context, 15),
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: _isInfoHovered ? 8 : 5,
                      sigmaY: _isInfoHovered ? 8 : 5,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: constraints.maxWidth,
                      height: constraints.maxHeight * 0.35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                            StoycoScreenSize.radius(context, 15),
                          ),
                          bottomRight: Radius.circular(
                            StoycoScreenSize.radius(context, 15),
                          ),
                        ),
                        color: _isInfoHovered
                            ? const Color.fromARGB(40, 255, 255, 255)
                            : const Color.fromARGB(15, 255, 255, 255),
                        border: Border.all(
                          width: StoycoScreenSize.width(context, 0.6),
                          color: const Color(0xFFd9d9d8),
                        ),
                      ),
                      child: Padding(
                        padding: StoycoScreenSize.symmetric(
                          context,
                          horizontal: 15.0,
                        ),
                        child: Column(
                          spacing: StoycoScreenSize.height(context, 5),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              widget.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: StoycoScreenSize.fontSize(
                                  context,
                                  16,
                                ),
                                fontWeight: FontWeight.w700,
                                overflow: TextOverflow.ellipsis,
                              ),
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textScaler: TextScaler.noScaling,
                            ),
                            Row(
                              spacing: StoycoScreenSize.width(context, 5),
                              children: <Widget>[
                                StoycoAssets.lib.assets.icons.events.calendarIco
                                    .svg(
                                      package: 'stoyco_subscription',
                                      width: StoycoScreenSize.width(
                                        context,
                                        15,
                                      ),
                                      height: StoycoScreenSize.height(
                                        context,
                                        15,
                                      ),
                                    ),
                                Flexible(
                                  child: Text(
                                    widget.date,
                                    style:
                                        widget.dateFontStyle ??
                                        TextStyle(
                                          color: Colors.white,
                                          fontSize: StoycoScreenSize.fontSize(
                                            context,
                                            12,
                                          ),
                                          fontWeight: FontWeight.w400,
                                        ),
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
