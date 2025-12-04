import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/images/image_network_blur.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/response/get_cultural_assets_response.dart';

/// {@template cultural_asset_card}
/// A card widget that displays information about a cultural asset.
///
/// Shows the asset image, title, and price in a styled card.
/// Tapping the card is intended to navigate to the asset's detail page (TODO).
///
/// The card includes:
/// - A network image with loading and error states.
/// - The asset's title centered below the image.
/// - A footer with a "Comprar" label and the asset's price with a coin icon.
///
/// **Priority Logic:**
/// - If the asset is sold out, it takes priority over locked state
/// - The sold out badge is displayed and blur effect is not applied
/// - Only if not sold out, the locked/unlocked state is evaluated
///
/// Example usage:
/// ```dart
/// CulturalAssetCard(
///   culturalAssetCard: CulturalAssetCardModel(
///     image: 'https://example.com/image.jpg',
///     title: 'Art Piece',
///     price: 100,
///   ),
/// )
/// ```
/// {@endtemplate}
class CulturalAssetCard extends StatelessWidget {
  /// Creates a [CulturalAssetCard].
  ///
  /// [culturalAssetCard] provides the data to display in the card.
  const CulturalAssetCard({
    super.key,
    required this.culturalAssetCard,
    this.onTap,
    this.onTapCulturalAssetExclusive,
  });

  /// The model containing the asset's image, title, and price.
  final CulturalAssetItemModel culturalAssetCard;

  /// Callback when the card is tapped and accessible.
  final void Function(CulturalAssetItemModel)? onTap;

  /// Callback when the locked cultural asset card is tapped.
  final VoidCallback? onTapCulturalAssetExclusive;

  /// Whether the asset is sold out (stock is 0).
  bool get isSoldOut => (culturalAssetCard.stock ?? 1) == 0;

  /// Whether the asset is locked (requires subscription and user doesn't have access).
  ///
  /// This is only evaluated if the asset is not sold out.
  bool get isLocked =>
      !isSoldOut && !culturalAssetCard.hasAccessWithSubscription;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isSoldOut ? 0.5 : 1.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(
          StoycoScreenSize.radius(context, 20),
        ),
        onTap: isSoldOut
            ? null
            : isLocked
            ? onTapCulturalAssetExclusive
            : () {
                if (onTap != null) {
                  onTap!(culturalAssetCard);
                }
              },
        child: SizedBox(
          width: StoycoScreenSize.width(context, 156),
          height: StoycoScreenSize.height(context, 226),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) =>
                Stack(
                  children: <Widget>[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: StoycoColors.cardDarkBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: StoycoColors.cardBorderDark,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Padding(
                                padding: StoycoScreenSize.all(context, 3),
                                child: ImageNetworkBlur(
                                  height: constraints.maxHeight * 0.65,
                                  width: double.infinity,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                      StoycoScreenSize.radius(context, 13),
                                    ),
                                    topRight: Radius.circular(
                                      StoycoScreenSize.radius(context, 13),
                                    ),
                                  ),
                                  imageUrl: culturalAssetCard.imageUri ?? '',
                                  isBlur: isLocked,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                          Gap(StoycoScreenSize.height(context, 9)),
                          Flexible(
                            child: Padding(
                              padding: StoycoScreenSize.all(context, 3),
                              child: Center(
                                child: Text(
                                  culturalAssetCard.name ?? '',
                                  style: TextStyle(
                                    fontSize: StoycoScreenSize.fontSize(
                                      context,
                                      14,
                                    ),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          Gap(StoycoScreenSize.height(context, 9)),
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(
                                StoycoScreenSize.radius(context, 16),
                              ),
                              bottomRight: Radius.circular(
                                StoycoScreenSize.radius(context, 16),
                              ),
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xff202532),
                                border: GradientBoxBorder(
                                  width: 0.9,
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: <Color>[
                                      Color(0xFFFFFFFF),
                                      Color(0xFFFFFFFF),
                                      Color.fromRGBO(255, 255, 255, 0),
                                      Color.fromRGBO(255, 255, 255, 0.4),
                                    ],
                                    stops: <double>[0.0, 0.2, 0.7, 1.0],
                                  ),
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                              child: Padding(
                                padding: StoycoScreenSize.symmetric(
                                  context,
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Comprar',
                                      style: TextStyle(
                                        fontSize: StoycoScreenSize.fontSize(
                                          context,
                                          12,
                                        ),
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        StoycoAssets
                                            .lib
                                            .assets
                                            .icons
                                            .culturalAssets
                                            .culturalAssetCoin
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
                                        SizedBox(
                                          width: StoycoScreenSize.width(
                                            context,
                                            4,
                                          ),
                                        ),
                                        Text(
                                          culturalAssetCard.stoyCoins
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: StoycoScreenSize.fontSize(
                                              context,
                                              12,
                                            ),
                                            fontWeight: FontWeight.w400,
                                            color: StoycoColors.text,
                                          ),
                                          maxLines: 1,
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSoldOut)
                      Positioned(
                        top: StoycoScreenSize.width(context, 80),
                        left: StoycoScreenSize.width(context, 20),
                        child: _buildSoldOut(context),
                      ),
                  ],
                ),
          ),
        ),
      ),
    );
  }

  /// Builds the (Sold Out) badge.
  Widget _buildSoldOut(BuildContext context) => Container(
    width: StoycoScreenSize.width(context, 119),
    height: StoycoScreenSize.height(context, 23),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: const Color(0xFF202532).withOpacity(0.85),
      border: Border.all(color: const Color(0xFFDE2424), width: 1),
    ),
    child: Center(
      child: Text(
        'Agotado',
        style: TextStyle(
          fontSize: StoycoScreenSize.fontSize(context, 10),
          color: const Color(0xFFFFFFFF),
          fontFamily: 'Akkurat Pro',
          fontWeight: FontWeight.w400,
          height: 1.6,
        ),
      ),
    ),
  );
}
