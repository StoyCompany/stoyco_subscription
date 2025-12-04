import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/skeletons/skeleton_card.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/cards/cultural_asset_card.dart';
import 'package:stoyco_subscription/designs/atomic/organisms/lock_subscription/basic_subs_card.dart';
import 'package:stoyco_subscription/designs/atomic/organisms/lock_subscription/subscription_indicator_position.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/response/get_cultural_assets_response.dart';

/// {@template cultural_assets_grid}
/// A grid widget that displays a list of cultural asset cards.
///
/// Shows a grid of [CulturalAssetCard] widgets with configurable columns and spacing.
/// While loading, displays skeleton cards as placeholders.
/// If the [culturalAssets] list is empty and not loading, nothing is shown.
///
/// **Priority Logic:**
/// - Sold out assets take priority over locked state
/// - If an asset is sold out, the "Contenido exclusivo" overlay is not shown
/// - Only non-sold-out assets can display the subscription lock overlay
///
/// Example usage:
/// ```dart
/// CulturalAssetsGrid(
///   culturalAssets: myAssetsList,
///   isLoading: false,
///   numberColumns: 2,
///   aspectRatio: 0.8,
/// )
/// ```
/// {@endtemplate}
/// {@template cultural_assets_grid}
/// A [CulturalAssetsGrid] organism for the Stoyco Subscription Atomic Design System.
///
/// ### Overview
/// Displays a grid of cultural asset cards, with loading skeletons. Shows a grid of [CulturalAssetCard] widgets, or skeleton placeholders when loading. If the asset list is empty and not loading, nothing is rendered.
///
/// ### Atomic Level
/// **Organism** – Composed of atoms and molecules (cards, skeletons, grid) for asset display and interaction.
///
/// ### Parameters
/// - `culturalAssets`: The list of cultural asset models to display in the grid.
/// - `isLoading`: Whether the grid is in a loading state and should show skeleton cards. Defaults to false.
/// - `onTapCulturalAssetExclusive`: Callback when a locked cultural asset card is tapped (optional).
/// - `numberColumns`: Number of columns in the grid. Defaults to 2.
/// - `mainAxisSpacing`: Spacing between rows. Defaults to 20.
/// - `crossAxisSpacing`: Spacing between columns. Defaults to 20.
/// - `aspectRatio`: Aspect ratio of each grid item. Defaults to 0.7.
/// - `scale`: Scale factor for locked content indicator. Defaults to 0.8.
/// - `key`: Optional widget key.
///
/// ### Returns
/// Renders a grid of asset cards or skeletons, suitable for atomic design systems.
///
/// ### Example
/// ```dart
/// CulturalAssetsGrid(
///   culturalAssets: myAssetsList,
///   isLoading: false,
///   numberColumns: 2,
/// )
/// ```
/// {@endtemplate}
class CulturalAssetsGrid extends StatelessWidget {
  /// Creates a [CulturalAssetsGrid].
  ///
  /// [culturalAssets] is the list of assets to display.
  /// [isLoading] determines whether to show skeleton loaders instead of real content.
  /// {@macro cultural_assets_grid}
  const CulturalAssetsGrid({
    super.key,
    required this.culturalAssets,
    this.isLoading = false,
    this.onTapSelectedCulturalAsset,
    this.onTapCulturalAssetExclusive,
    this.numberColumns = 2,
    this.mainAxisSpacing = 20,
    this.crossAxisSpacing = 20,
    this.aspectRatio = 0.7,
    this.scale = 0.8,
  });

  /// The list of cultural asset models to display in the grid.
  final List<CulturalAssetItemModel> culturalAssets;

  /// Whether the grid is in a loading state and should show skeleton cards. Defaults to false.
  final bool isLoading;

  final ValueChanged<CulturalAssetItemModel>? onTapSelectedCulturalAsset;

  /// Callback when a locked cultural asset card is tapped (optional).
  final VoidCallback? onTapCulturalAssetExclusive;

  /// Number of columns in the grid. Defaults to 2.
  final int numberColumns;

  /// Spacing between rows. Defaults to 20.
  final double mainAxisSpacing;

  /// Spacing between columns. Defaults to 20.
  final double crossAxisSpacing;

  /// Aspect ratio of each grid item. Defaults to 0.7.
  final double aspectRatio;

  /// Scale factor for locked content indicator. Defaults to 0.8.
  final double scale;

  @override
  Widget build(BuildContext context) {
    if (culturalAssets.isEmpty && !isLoading) {
      return const SizedBox.shrink();
    }

    return Column(
      children: <Widget>[
        Gap(StoycoScreenSize.height(context, 15)),
        GridView.builder(
          clipBehavior: Clip.none,
          shrinkWrap: true,
          padding: StoycoScreenSize.symmetric(context, horizontal: 20),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: numberColumns,
            mainAxisSpacing: StoycoScreenSize.width(context, mainAxisSpacing),
            crossAxisSpacing: StoycoScreenSize.width(context, crossAxisSpacing),
            childAspectRatio: aspectRatio,
          ),
          itemCount: isLoading ? 3 : culturalAssets.length,
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

            if (index >= culturalAssets.length) {
              return const SizedBox.shrink();
            }

            final CulturalAssetItemModel asset = culturalAssets[index];
            final bool isSoldOut = (asset.stock ?? 1) == 0;

            // Only show locked overlay if not sold out (sold out takes priority)
            final bool isLocked =
                !isSoldOut &&
                asset.isSubscriberOnly &&
                !asset.hasAccessWithSubscription;

            return SubscriptionLockedContent(
              scale: scale,
              isLocked: isLocked,
              indicatorPosition: const SubscriptionIndicatorPosition(
                left: 0,
                top: 25,
              ),
              onLockedTap: onTapCulturalAssetExclusive,
              child: CulturalAssetCard(
                key: ValueKey<String>('cultural_asset_$index'),
                culturalAssetCard: asset,
                onTapCulturalAssetExclusive: onTapCulturalAssetExclusive,
                onTap: onTapSelectedCulturalAsset,
              ),
            );
          },
        ),
      ],
    );
  }
}
