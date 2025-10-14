import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/cultural_asset_card_model.dart';

class CulturalAssetCard extends StatelessWidget {
  const CulturalAssetCard({super.key, required this.culturalAssetCard});
  final CulturalAssetCardModel culturalAssetCard;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(StoycoScreenSize.radius(context, 20)),
      onTap: () {
        //Todo: Navigate to cultural asset detail
      },
      child: SizedBox(
        width: StoycoScreenSize.width(context, 156),
        height: StoycoScreenSize.height(context, 226),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFF12191F),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF222b3d),
                    width: StoycoScreenSize.width(context, 2.5),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: StoycoScreenSize.radius(context, 35),
                    ),
                  ],
                ),
                child: Column(
                  spacing: StoycoScreenSize.height(context, 9),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: StoycoScreenSize.all(context, 3),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                            StoycoScreenSize.radius(context, 13),
                          ),
                          topRight: Radius.circular(
                            StoycoScreenSize.radius(context, 13),
                          ),
                        ),
                        child: CachedNetworkImage(
                          height: constraints.maxHeight * 0.65,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          imageUrl: culturalAssetCard.image,
                          placeholder: (BuildContext context, String url) =>
                              const DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black45,
                                    ),
                                  ),
                                ),
                              ),
                          errorWidget:
                              (
                                BuildContext context,
                                String url,
                                Object error,
                              ) => const Icon(Icons.error),
                        ),
                      ),
                    ),
                    Padding(
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
                        decoration: BoxDecoration(
                          color: const Color(0xFF191F27),
                          border: Border.all(
                            width: 1,
                            style: BorderStyle.solid,
                            color: StoycoColors.white,
                          ),
                          borderRadius: const BorderRadius.only(
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
