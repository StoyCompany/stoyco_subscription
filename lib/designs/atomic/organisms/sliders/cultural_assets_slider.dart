import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/skeletons/skeleton_card.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/cards/cultural_asset_card.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/response/get_cultural_assets_response.dart';

/// {@template cultural_assets_slider}
/// A horizontal slider widget that displays a list of cultural asset cards.
///
/// Shows a section title and a horizontally scrollable list of [CulturalAssetCard] widgets.
/// While loading, displays a row of skeleton cards as placeholders.
/// If the [culturalAssets] list is empty and not loading, nothing is shown.
///
/// Example usage:
/// ```dart
/// CulturalAssetsSlider(
///   culturalAssets: myAssetsList,
///   isLoading: false,
/// )
/// ```
/// {@endtemplate}
/// {@template cultural_assets_slider}
/// A [CulturalAssetsSlider] organism for the Stoyco Subscription Atomic Design System.
///
/// ### Overview
/// Displays a horizontal slider of cultural asset cards, with a section title and loading skeletons. Shows a scrollable list of [CulturalAssetCard] widgets, or skeleton placeholders when loading. If the asset list is empty and not loading, nothing is rendered.
///
/// ### Atomic Level
/// **Organism** – Composed of atoms and molecules (cards, skeletons, slider) for asset display and interaction.
///
/// ### Parameters
/// - `culturalAssets`: The list of cultural asset models to display in the slider.
/// - `isLoading`: Whether the slider is in a loading state and should show skeleton cards. Defaults to false.
/// - `onTapCulturalAssetExclusive`: Callback when a locked cultural asset card is tapped (optional).
/// - `key`: Optional widget key.
///
/// ### Returns
/// Renders a column with a section title and a horizontally scrollable list of asset cards or skeletons, suitable for atomic design systems.
///
/// ### Example
/// ```dart
/// CulturalAssetsSlider(
///   culturalAssets: myAssetsList,
///   isLoading: false,
/// )
/// ```
/// {@endtemplate}
class CulturalAssetsSlider extends StatelessWidget {
  /// Creates a [CulturalAssetsSlider].
  ///
  /// [culturalAssets] is the list of assets to display.
  /// [isLoading] determines whether to show skeleton loaders instead of real content.
  /// {@macro cultural_assets_slider}
  const CulturalAssetsSlider({
    super.key,
    required this.culturalAssets,
    this.isLoading = false,
    this.onTapSelectedCulturalAsset,
    this.onTapCulturalAssetExclusive,
  });

  /// The list of cultural asset models to display in the slider.
  final List<CulturalAssetItemModel> culturalAssets;

  /// Whether the slider is in a loading state and should show skeleton cards. Defaults to false.
  final bool isLoading;

  final ValueChanged<CulturalAssetItemModel>? onTapSelectedCulturalAsset;

  /// Callback when a locked cultural asset card is tapped (optional).
  final VoidCallback? onTapCulturalAssetExclusive;

  @override
  Widget build(BuildContext context) {
    if (culturalAssets.isEmpty && !isLoading) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: StoycoScreenSize.height(context, 226),
      width: double.infinity,
      child: ListView.separated(
        clipBehavior: Clip.none,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        separatorBuilder: (BuildContext context, int index) =>
            Gap(StoycoScreenSize.width(context, 20)),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: isLoading ? 5 : culturalAssets.length,
        itemBuilder: (BuildContext context, int index) {
          if (isLoading) {
            return SkeletonCard(
              width: StoycoScreenSize.width(context, 156),
              height: StoycoScreenSize.height(context, 226),
              borderRadius: BorderRadius.circular(
                StoycoScreenSize.radius(context, 20),
              ),
            );
          }

          final CulturalAssetItemModel asset = culturalAssets[index];
          return CulturalAssetCard(
            culturalAssetCard: asset,
            onTapCulturalAssetExclusive: onTapCulturalAssetExclusive,
            onTap: onTapSelectedCulturalAsset,
          );
        },
      ),
    );
  }
}
