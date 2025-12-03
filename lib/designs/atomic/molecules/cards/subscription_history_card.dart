import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/images/image_network_blur.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/designs/utils/formatter_dates.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/data/models/responses/user_subscription_plan_response.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/models/enums/subscription_status.enum.dart';

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
    this.onTapSubscriptionHistoryCard,
  });

  /// The model containing the subscription history item data.
  final UserSubscriptionPlan subscriptionHistoryItem;

  final void Function(String partnerId)? onTapSubscriptionHistoryCard;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          onTapSubscriptionHistoryCard?.call(subscriptionHistoryItem.partnerId),
      child: Container(
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
              ImageNetworkBlur(
                imageUrl: subscriptionHistoryItem.planImageUrl,
                radius: StoycoScreenSize.radius(context, 9),
                width: double.infinity,
                height: StoycoScreenSize.height(context, 164),
                fit: BoxFit.cover,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          '${StoycoDateFormatters.formatIso8601AsDayMonthAbbrYear(subscriptionHistoryItem.subscriptionStartDate)} - ${StoycoDateFormatters.formatIso8601AsDayMonthAbbrYear(subscriptionHistoryItem.subscriptionEndDate)}',
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
                              fontSize: StoycoScreenSize.fontSize(context, 12),
                            ),
                          ),
                          backgroundColor:
                              subscriptionHistoryItem.planStatus ==
                                  SubscriptionStatus.active
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
                            subscriptionHistoryItem.planStatus ==
                                    SubscriptionStatus.active
                                ? 'Activo'
                                : 'Inactivo',
                          ),
                        ),

                        (subscriptionHistoryItem.planIsDeleted)
                            ? const SizedBox.shrink()
                            : Text(
                                (subscriptionHistoryItem.planStatus ==
                                        SubscriptionStatus.active)
                                    ? 'Ver suscripción'
                                    : 'Ver planes',
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    color: StoycoColors.softWhite,
                                    fontWeight: FontWeight.w400,
                                    fontSize: StoycoScreenSize.fontSize(
                                      context,
                                      12,
                                    ),
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
      ),
    );
  }
}
