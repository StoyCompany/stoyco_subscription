import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/skeletons/skeleton_card.dart';
import 'package:stoyco_subscription/designs/atomic/organisms/cards/event_card_exclusive_locked.dart';
import 'package:stoyco_subscription/designs/atomic/templates/sliders/events/events_slider_style.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// {@template events_slider}
/// An [EventsSlider] template for the Stoyco Subscription Atomic Design System.
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
class EventsSlider<T> extends StatelessWidget {
  /// {@macro events_slider}
  const EventsSlider({
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
    this.isLoading = false,
    this.style = const EventsSliderStyle(),
  });

  /// Title of the slider. Defaults to 'Experiencias'.
  final String title;
  /// Returns whether the event is locked.
  final bool Function(T event) getIsLocked;
  /// Returns the name value for an event.
  final String Function(T event) getName;
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
  /// Style model for all design parameters. Defaults to [EventsSliderStyle].
  final EventsSliderStyle style;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty && !isLoading) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        spacing: StoycoScreenSize.height(context, 9),
      children: <Widget>[
        Padding(
          padding: StoycoScreenSize.symmetric(context, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: StoycoScreenSize.fontSize(context, 20),
                  fontWeight: FontWeight.bold,
                  color: StoycoColors.text,
                  fontFamily: FontFamilyToken.akkuratPro,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: StoycoScreenSize.height(context, style.heightCard),
          width: double.infinity,
          child: ListView.separated(
            clipBehavior: Clip.none,
            shrinkWrap: true,
            padding: StoycoScreenSize.symmetric(context, horizontal: 20),
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(width: StoycoScreenSize.width(context, 20),);
            },
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: isLoading ? 3 : events.length,
            itemBuilder: (BuildContext context, int index) {
              if (isLoading) {
                return SkeletonCard(
                  width: StoycoScreenSize.width(context, style.widthCard),
                  height: StoycoScreenSize.height(context, style.heightCard),
                  borderRadius: BorderRadius.circular(style.borderRadiusCard),
                );
              }
              final T event = events[index];
              return EventCardExclusiveLocked(
                key: ValueKey<String>('event_exclusive_locked_$index'),
                imageUrl: getImageUrl(event),
                name: getName(event),
                isFinished: getIsFinished(event),
                date: getDate(event),
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
              );
            },
          ),
        ),
        Gap(StoycoScreenSize.height(context, 20)),
      ],
    );
  }
}
