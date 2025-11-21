import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/images/image_network_blur.dart';
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
class EventCardExclusiveLockedV2 extends StatefulWidget {
  /// {@macro event_card_exclusive_locked}
  const EventCardExclusiveLockedV2({
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
    this.widthCard = 172,
    this.borderRadiusCard = 8,
    this.backgroundColorCard = StoycoColors.white2,
    this.paddingContentCard,
    this.nameFontStyle,
    this.dateFontStyle,
    this.valueMoney,
  });

  /// The main image URL for the event card.
  final String imageUrl;

  /// The event name to display.
  final String name;

  /// The event date to display.
  final String date;

  final String? valueMoney;

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
  State<EventCardExclusiveLockedV2> createState() =>
      _EventCardExclusiveLockedState();
}

class _EventCardExclusiveLockedState extends State<EventCardExclusiveLockedV2> {
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
      child: Container(
        decoration: BoxDecoration(
          color: StoycoColors.gray,
          borderRadius: BorderRadius.all(
            Radius.circular(StoycoScreenSize.radius(context, 8)),
          ),
        ),
        width: StoycoScreenSize.width(context, widget.widthCard),
        height: StoycoScreenSize.height(context, widget.heightCard),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(StoycoScreenSize.radius(context, 8)),
                  topRight: Radius.circular(
                    StoycoScreenSize.radius(context, 8),
                  ),
                ),
                child: ImageNetworkBlur(
                  height: StoycoScreenSize.height(context, 152),
                  width: double.infinity,
                  imageUrl: widget.imageUrl,
                  isBlur: !widget.isFinished && widget.isLocked,
                  alignment: Alignment.topCenter,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: StoycoScreenSize.height(context, 8),
                  horizontal: StoycoScreenSize.width(context, 8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.name,
                      style: TextStyle(
                        color: StoycoColors.white3,
                        fontSize: StoycoScreenSize.fontSize(context, 14),
                        fontWeight: FontWeight.w700,
                        overflow: TextOverflow.ellipsis,
                      ),
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textScaler: TextScaler.noScaling,
                    ),
                    Gap(StoycoScreenSize.height(context, 8)),
                    Text(
                      widget.date,
                      style: TextStyle(
                        color: StoycoColors.white3,
                        fontSize: StoycoScreenSize.fontSize(context, 12),
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis,
                      ),
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textScaler: TextScaler.noScaling,
                    ),

                    Gap(
                      StoycoScreenSize.height(
                        context,
                        widget.valueMoney != null && widget.valueMoney != ''
                            ? 8
                            : 0,
                      ),
                    ),
                    if (widget.valueMoney != null && widget.valueMoney != '')
                      Text(
                        widget.valueMoney!,
                        style: TextStyle(
                          color: StoycoColors.white3,
                          fontSize: StoycoScreenSize.fontSize(context, 8),
                          fontWeight: FontWeight.w400,
                          overflow: TextOverflow.ellipsis,
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textScaler: TextScaler.noScaling,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
