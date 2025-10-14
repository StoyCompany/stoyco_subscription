import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/skeletons/skeleton_card.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/cards/cultural_asset_card.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/cultural_asset_card_model.dart';

class CulturalAssetsSlider extends StatelessWidget {
  const CulturalAssetsSlider({
    super.key,
    required this.culturalAssets,
    this.isLoading = false,
  });

  final List<CulturalAssetCardModel> culturalAssets;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: StoycoScreenSize.symmetric(context, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Activos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: FontFamilyToken.akkuratPro,
                    fontSize: StoycoScreenSize.fontSize(context, 20),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: StoycoScreenSize.height(context, 9)),
          SizedBox(
            height: StoycoScreenSize.height(context, 226),
            child: ListView.separated(
              clipBehavior: Clip.none,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(width: 20),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) => SkeletonCard(
                width: StoycoScreenSize.width(context, 156),
                height: StoycoScreenSize.height(context, 226),
                borderRadius: BorderRadius.circular(StoycoScreenSize.radius(context, 20)),
              ),
            ),
          ),
        ],
      );
    }

    if (culturalAssets.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: StoycoScreenSize.symmetric(context, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Activos',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: FontFamilyToken.akkuratPro,
                  fontSize: StoycoScreenSize.fontSize(context, 20),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: StoycoScreenSize.height(context, 9)),
        SizedBox(
          height: StoycoScreenSize.height(context, 226),
          width: double.infinity,
          child: ListView.separated(
            clipBehavior: Clip.none,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            separatorBuilder: (BuildContext context, int index) =>
                SizedBox(width: StoycoScreenSize.width(context, 20)),
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: culturalAssets.length,
            itemBuilder: (BuildContext context, int index) =>
                CulturalAssetCard(culturalAssetCard: culturalAssets[index]),
          ),
        ),
      ],
    );
  }
}
