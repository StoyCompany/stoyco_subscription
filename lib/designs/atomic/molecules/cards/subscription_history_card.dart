import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/subscription_history/data/models/subscription_history_response.dart';

/// {@template subscription_history_card}
/// A card widget that displays information about a user's subscription history item.
///
/// Shows the plan image, partner name, plan name, recurrence type, price, currency,
/// subscription period, and the subscription status (active/inactive).
/// Also provides a call to action ("Ver suscripción" or "Ver planes") depending on the status.
///
/// Example usage:
/// ```dart
/// SubscriptionHistoryCard(
///   subscriptionHistoryItem: mySubscriptionHistoryItem,
/// )
/// ```
/// {@endtemplate}
class SubscriptionHistoryCard extends StatelessWidget {
  /// Creates a [SubscriptionHistoryCard].
  ///
  /// [subscriptionHistoryItem] provides the data to display in the card.
  const SubscriptionHistoryCard({
    super.key,
    required this.subscriptionHistoryItem,
  });

  /// The model containing the subscription history item data.
  final SubscriptionHistoryItem subscriptionHistoryItem;

  /// Formats a date string (ISO 8601) to 'dd MMM yyyy', e.g., '25 oct 2024'.
  String _formatDate(String dateStr) {
    try {
      final DateTime date = DateTime.parse(dateStr);
      const List<String> months = [
        'ene',
        'feb',
        'mar',
        'abr',
        'may',
        'jun',
        'jul',
        'ago',
        'sep',
        'oct',
        'nov',
        'dic',
      ];
      final String month = months[date.month - 1];
      return '${date.day.toString().padLeft(2, '0')} $month ${date.year}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: StoycoColors.backgroundGrey,
        borderRadius: BorderRadius.circular(
          StoycoScreenSize.radius(context, 16),
        ),
      ),
      child: Padding(
        padding: StoycoScreenSize.all(context, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: StoycoScreenSize.height(context, 8),
          children: <Widget>[
            Text(
              'Te suscribiste a: ',
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  color: StoycoColors.softWhite,
                  fontWeight: FontWeight.w700,
                  fontSize: StoycoScreenSize.fontSize(context, 12),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadiusGeometry.all(
                Radius.circular(StoycoScreenSize.radius(context, 9)),
              ),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: subscriptionHistoryItem.planImageUrl,
                placeholder: (BuildContext context, String url) =>
                    const DecoratedBox(
                      decoration: BoxDecoration(color: Colors.black12),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.black45,
                          ),
                        ),
                      ),
                    ),
                errorWidget: (BuildContext context, String url, Object error) =>
                    const Icon(Icons.error),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: StoycoScreenSize.width(context, 25),
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: StoycoScreenSize.width(context, 177),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: StoycoScreenSize.height(context, 4),
                    children: <Widget>[
                      Text(
                        subscriptionHistoryItem.partnerName,
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: StoycoColors.softWhite,
                            fontWeight: FontWeight.w700,
                            fontSize: StoycoScreenSize.fontSize(context, 16),
                          ),
                        ),
                      ),
                      Text(
                        '${subscriptionHistoryItem.planName} (${subscriptionHistoryItem.recurrenceType}) ${subscriptionHistoryItem.price} ${subscriptionHistoryItem.currencyCode}',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: StoycoColors.softWhite,
                            fontWeight: FontWeight.w400,
                            fontSize: StoycoScreenSize.fontSize(context, 12),
                          ),
                        ),
                      ),
                      Text(
                        '${_formatDate(subscriptionHistoryItem.subscriptionStartDate)} - ${_formatDate(subscriptionHistoryItem.subscriptionEndDate)}',
                        style: TextStyle(
                          fontFamily: FontFamilyToken.akkuratPro,
                          color: StoycoColors.hint,
                          fontWeight: FontWeight.w400,
                          fontSize: StoycoScreenSize.fontSize(context, 12),
                        ),
                      ),
                    ],
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: StoycoScreenSize.width(context, 100),
                  ),
                  child: Column(
                    spacing: StoycoScreenSize.height(context, 4),
                    children: <Widget>[
                      Chip(
                        labelStyle: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: StoycoColors.deepCharcoal,
                            fontWeight: FontWeight.w400,
                            fontSize: StoycoScreenSize.fontSize(
                              context,
                              12,
                            ),
                          ),
                        ),
                        backgroundColor: subscriptionHistoryItem.subscribedIsActive
                            ? StoycoColors.activeChip
                            : StoycoColors.inactiveChip,
                        padding: StoycoScreenSize.symmetric(
                          context,
                          horizontal: 12,
                          vertical: 4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            StoycoScreenSize.radius(context, 13),
                          ),
                        ),
                        label: Text(
                          subscriptionHistoryItem.subscribedIsActive
                              ? 'Activo'
                              : 'Inactivo',
                        ),
                      ),
                      Text(
                        (subscriptionHistoryItem.subscribedIsActive)
                            ? 'Ver suscripción'
                            : 'Ver planes',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: StoycoColors.softWhite,
                            fontWeight: FontWeight.w400,
                            fontSize: StoycoScreenSize.fontSize(context, 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
