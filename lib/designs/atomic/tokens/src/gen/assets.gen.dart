// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $LibGen {
  const $LibGen();

  /// Directory path: lib/assets
  $LibAssetsGen get assets => const $LibAssetsGen();
}

class $LibAssetsGen {
  const $LibAssetsGen();

  /// Directory path: lib/assets/colors
  $LibAssetsColorsGen get colors => const $LibAssetsColorsGen();

  /// Directory path: lib/assets/icons
  $LibAssetsIconsGen get icons => const $LibAssetsIconsGen();

  /// Directory path: lib/assets/mocks
  $LibAssetsMocksGen get mocks => const $LibAssetsMocksGen();
}

class $LibAssetsColorsGen {
  const $LibAssetsColorsGen();

  /// File path: lib/assets/colors/colors.xml
  String get colors => 'lib/assets/colors/colors.xml';

  /// List of all assets
  List<String> get values => [colors];
}

class $LibAssetsIconsGen {
  const $LibAssetsIconsGen();

  /// File path: lib/assets/icons/alert_icon.svg
  SvgGenImage get alertIcon =>
      const SvgGenImage('lib/assets/icons/alert_icon.svg');

  /// File path: lib/assets/icons/arrow_right.svg
  SvgGenImage get arrowRight =>
      const SvgGenImage('lib/assets/icons/arrow_right.svg');

  /// File path: lib/assets/icons/double_right_arrow.svg
  SvgGenImage get doubleRightArrow =>
      const SvgGenImage('lib/assets/icons/double_right_arrow.svg');

  /// File path: lib/assets/icons/exclamacion.svg
  SvgGenImage get exclamacion =>
      const SvgGenImage('lib/assets/icons/exclamacion.svg');

  /// File path: lib/assets/icons/search_navbar.svg
  SvgGenImage get searchNavbar =>
      const SvgGenImage('lib/assets/icons/search_navbar.svg');

  /// File path: lib/assets/icons/star.svg
  SvgGenImage get star => const SvgGenImage('lib/assets/icons/star.svg');

  /// File path: lib/assets/icons/subsciption_button_icon.svg
  SvgGenImage get subsciptionButtonIcon =>
      const SvgGenImage('lib/assets/icons/subsciption_button_icon.svg');

  /// File path: lib/assets/icons/subscription_icon.svg
  SvgGenImage get subscriptionIcon =>
      const SvgGenImage('lib/assets/icons/subscription_icon.svg');

  /// File path: lib/assets/icons/subscription_icon_web.svg
  SvgGenImage get subscriptionIconWeb =>
      const SvgGenImage('lib/assets/icons/subscription_icon_web.svg');

  /// File path: lib/assets/icons/tag_subscription.svg
  SvgGenImage get tagSubscription =>
      const SvgGenImage('lib/assets/icons/tag_subscription.svg');

  /// File path: lib/assets/icons/tag_subscription_slim.svg
  SvgGenImage get tagSubscriptionSlim =>
      const SvgGenImage('lib/assets/icons/tag_subscription_slim.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
    alertIcon,
    arrowRight,
    doubleRightArrow,
    exclamacion,
    searchNavbar,
    star,
    subsciptionButtonIcon,
    subscriptionIcon,
    subscriptionIconWeb,
    tagSubscription,
    tagSubscriptionSlim,
  ];
}

class $LibAssetsMocksGen {
  const $LibAssetsMocksGen();

  /// File path: lib/assets/mocks/subscription_plan_by_user.json
  String get subscriptionPlanByUser =>
      'lib/assets/mocks/subscription_plan_by_user.json';

  /// List of all assets
  List<String> get values => [subscriptionPlanByUser];
}

class StoycoAssets {
  const StoycoAssets._();

  static const $LibGen lib = $LibGen();
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package = 'stoyco_subscription',
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    _svg.ColorMapper? colorMapper,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
        colorMapper: colorMapper,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
