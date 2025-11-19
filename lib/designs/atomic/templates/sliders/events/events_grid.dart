import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/skeletons/skeleton_card.dart';
import 'package:stoyco_subscription/designs/atomic/organisms/cards/event_card_exclusive_locked.dart';
import 'package:stoyco_subscription/designs/atomic/organisms/cards/event_card_exclusive_locked_v2.dart';
import 'package:stoyco_subscription/designs/atomic/organisms/lock_subscription/basic_subs_card.dart';
import 'package:stoyco_subscription/designs/atomic/organisms/lock_subscription/subscription_indicator_position.dart';
import 'package:stoyco_subscription/designs/atomic/templates/sliders/events/events_slider_style.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// {@template events_slider}
/// An [EventsGrid] template for the Stoyco Subscription Atomic Design System.
///
/// ### Overview
/// Displays a horizontal slider of event cards, with a section title and loading skeletons. Shows a scrollable list of [EventCardExclusiveLocked] widgets, or skeleton placeholders when loading. Highly customizable via generic data and style parameters.
///
/// ### Atomic Level
/// **Template** – High-level layout structure composed of organisms, molecules, and atoms for event display and interaction.
///
/// ### Parameters
/// - `title`: Title of the slider. Defaults to 'Experiencias'.
/// - `getIsLocked`: Returns whether the event is locked.
/// - `getName`: Returns the name value for an event.
/// - `getIsFinished`: Returns whether the event is finished.
/// - `getDate`: Returns the date value for an event.
/// - `getImageUrl`: Returns the imageUrl value for an event.
/// - `onTapEvent`: Called when an event is tapped.
/// - `onTapEventExclusive`: Called when an exclusive event is tapped.
/// - `events`: List of events to display in the slider.
/// - `isLoading`: Whether the slider is in a loading state. Defaults to false.
/// - `style`: Style model for all design parameters. Defaults to [EventsSliderStyle].
/// - `key`: Optional widget key.
///
/// ### Returns
/// Renders a column with a section title and a horizontally scrollable list of event cards or skeletons, suitable for atomic design systems.
///
/// ### Example
/// ```dart
/// EventsSlider<EventModel>(
///   events: myEvents,
///   getName: (e) => e.name,
///   getDate: (e) => e.date,
///   getIsFinished: (e) => e.isFinished,
///   getImageUrl: (e) => e.imageUrl,
///   getIsLocked: (e) => e.isLocked,
///   onTapEvent: (e) => print('Tap: \\${e.name}'),
///   onTapEventExclusive: (e) => print('Exclusive: \\${e.name}'),
/// )
/// ```
/// {@endtemplate}
class EventsGrid<T> extends StatelessWidget {
  /// {@macro events_slider}
  const EventsGrid({
    super.key,
    this.title = 'Experiencias',
    required this.getName,
    required this.getDate,
    required this.getIsFinished,
    required this.getImageUrl,
    required this.getIsLocked,
    required this.events,
    required this.onTapEvent,
    required this.onTapEventExclusive,
    required this.getValueMoney,
    required this.apectRatio,
    this.numberColums = 2,
    this.mainAxisSpacing = 20,
    this.crossAxisSpacing = 20,
    this.scale = 0.8,
    this.isLoading = false,
    this.style = const EventsSliderStyle(),
  });

  /// Title of the slider. Defaults to 'Experiencias'.
  final String title;

  /// Returns whether the event is locked.
  final bool Function(T event) getIsLocked;

  /// Returns the name value for an event.
  final String Function(T event) getName;

  /// Returns the name value for an event.
  final String Function(T event) getValueMoney;

  /// Returns whether the event is finished.
  final bool Function(T event) getIsFinished;

  /// Returns the date value for an event.
  final String Function(T event) getDate;

  /// Returns the imageUrl value for an event.
  final String Function(T event) getImageUrl;

  /// Called when an event is tapped.
  final ValueChanged<T> onTapEvent;

  /// Called when an exclusive event is tapped.
  final ValueChanged<T> onTapEventExclusive;

  /// List of events to display in the slider.
  final List<T> events;

  /// Whether the slider is in a loading state. Defaults to false.
  final bool isLoading;

  final double apectRatio;

  final int numberColums;

  final double mainAxisSpacing;

  final double crossAxisSpacing;

  final double scale;

  /// Style model for all design parameters. Defaults to [EventsSliderStyle].
  final EventsSliderStyle style;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty && !isLoading) {
      return const SizedBox.shrink();
    }

    return GridView.builder(
      clipBehavior: Clip.none,
      shrinkWrap: true,
      padding: StoycoScreenSize.symmetric(context, horizontal: 20),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: numberColums, // porque antes era un slider horizontal
        mainAxisSpacing: StoycoScreenSize.width(context, mainAxisSpacing),
        crossAxisSpacing: StoycoScreenSize.width(context, crossAxisSpacing),
        childAspectRatio: apectRatio,
      ),
      itemCount: isLoading ? 3 : events.length,
      itemBuilder: (BuildContext context, int index) {
        if (isLoading) {
          return SkeletonCard(
            width: StoycoScreenSize.width(context, style.widthCard),
            height: StoycoScreenSize.height(context, style.heightCard),
            borderRadius: BorderRadius.circular(style.borderRadiusCard),
          );
        }

        if (index >= events.length) {
          return const SizedBox.shrink();
        }

        final T event = events[index];
        return SubscriptionLockedContent(
          scale: scale,
          isLocked: getIsLocked(event),
          indicatorPosition: const SubscriptionIndicatorPosition(
            left: 0,
            top: 25,
          ),
          child: EventCardExclusiveLockedV2(
            key: ValueKey<String>('event_exclusive_locked_$index'),
            imageUrl: getImageUrl(event),
            name: getName(event),
            isFinished: getIsFinished(event),
            date: getDate(event),
            valueMoney: getValueMoney(event),
            isLocked: getIsLocked(event),
            onTapEvent: () => onTapEvent(event),
            onTapEventExclusive: () => onTapEventExclusive(event),
            backgroundColorCard: style.backgroundColorCard,
            borderRadiusCard: style.borderRadiusCard,
            nameFontStyle: style.nameFontStyle,
            dateFontStyle: style.dateFontStyle,
            heightCard: style.heightCard,
            widthCard: style.widthCard,
            imageError: style.imageError,
            imagePlaceholder: style.imagePlaceholder,
            paddingContentCard: style.paddingContentCard,
          ),
        );
      },
    );
  }
}
