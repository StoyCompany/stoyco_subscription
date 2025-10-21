import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/images/image_network_blur.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/tags/tag_locked.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/cultural_asset_card_model.dart';

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
    this.onTapCulturalAssetExclusive,
  });

  /// The model containing the asset's image, title, and price.
  final CulturalAssetCardModel culturalAssetCard;

  /// Callback when the locked cultural asset card is tapped.
  final VoidCallback? onTapCulturalAssetExclusive;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(StoycoScreenSize.radius(context, 20)),
      onTap: culturalAssetCard.hasAccess 
      ? (){
        //Todo: Navigate to cultural asset detail
      } 
      : onTapCulturalAssetExclusive,
      child: SizedBox(
        width: StoycoScreenSize.width(context, 156),
        height: StoycoScreenSize.height(context, 226),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              DecoratedBox(
                decoration: BoxDecoration(
                  color: StoycoColors.cardDarkBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: StoycoColors.cardBorderDark,
                    width: 1.5,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: StoycoScreenSize.radius(context, 35),
                    ),
                  ],
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
                              topLeft: Radius.circular(StoycoScreenSize.radius(context, 13)),
                              topRight: Radius.circular(StoycoScreenSize.radius(context, 13)),
                            ),
                            imageUrl: culturalAssetCard.image,
                            isBlur: !culturalAssetCard.hasAccess,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: TagLocked(
                            isLocked: !culturalAssetCard.hasAccess,
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
                            culturalAssetCard.title,
                            style: TextStyle(
                              fontSize: StoycoScreenSize.fontSize(context, 14),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                spacing: StoycoScreenSize.width(context, 4),
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  StoycoAssets
                                      .lib
                                      .assets
                                      .icons
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
                                  Text(
                                    culturalAssetCard.price.toString(),
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
        ),
      ),
    );
  }
}
