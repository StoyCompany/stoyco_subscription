import 'package:flutter/widgets.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';

class SubscriptionPlanScreenStyleParams {
  /// Main style parameters for SubscriptionPlanScreen.
  /// Organized by logical blocks for maintainability and clarity.
  const SubscriptionPlanScreenStyleParams({
    // ----------- Title & Description Styles -----------
    this.titleStyle,
    this.textDescriptionStyle,
    // ----------- Subscription Tag Dimensions -----------
    this.tagSubscriptionWidth,
    this.tagSubscriptionHeight,
    // ----------- Plan Font Sizes -----------
    this.currencyFontSize = 14,
    this.priceFontSize = 40,
    this.titleFontSize = 28,
    // ----------- Currency Flag -----------
    this.currencyFlagHeight = 16,
    this.currencyFlagWidth = 24,
    // ----------- Dropdown Styles -----------
    this.htmlDropdownContentPadding,
    this.htmlDropdownSelectorPadding,
    this.htmlDropdownTitleTextStyle,
    // ----------- Information Message -----------
    this.exclamationIconWidth,
    this.exclamationIconHeight,
    this.messageInformationPadding,
    this.messageInformationTextStyle,
    // ----------- Action Button Paddings -----------
    this.onTapFreeTrialPadding,
    this.onTapContinuePadding,
    this.onTapRenewSubscriptionPadding,
    this.onTapCancelSubscriptionPadding,
    // ----------- Discount Message Style -----------
    this.planMessageDiscountTextStyle,
    // ----------- Tag Corner -----------
    this.tagCornerHeight = 100,
    this.tagCornerWidth = 100,
    this.tagCornerCutSize = 48,
    this.tagCornerRadius = 5,
    this.tagCornerPaddingText,
    this.tagCornerTextStyle,
    this.tagCornerColor = StoycoColors.blue,
    this.tagCornerGradientColorsBorder = const <Color>[
      StoycoColors.transparent,
      StoycoColors.transparent,
      StoycoColors.cardBorderGradientWhite05,
      StoycoColors.cardBorderGradientWhite05,
      StoycoColors.cardBorderGradientWhite15,
      StoycoColors.cardBorderGradientWhite15,
      StoycoColors.cardBorderGradientWhite05,
      StoycoColors.cardBorderGradientWhite15,
      StoycoColors.cardBorderGradientWhite05,
      StoycoColors.cardBorderGradientWhite05,
      StoycoColors.cardBorderGradientWhite05,
      StoycoColors.transparent,
      StoycoColors.transparent,
    ],
    // ----------- Tag Gradient -----------
    this.tagGradientHeight = 29,
    this.tagGradientWidth,
    this.tagGradientMargin,
    this.tagGradientPadding,
    this.tagGradientTitleStyle,
    this.tagGradientBorderRadius = 100,
    this.tagGradientGradient = const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: <Color>[
        StoycoColors.tagGradientWhite18,
        StoycoColors.tagGradientGray25,
        StoycoColors.tagGradientBlack45,
        StoycoColors.tagGradientDark65,
        StoycoColors.tagGradientBlack85,
      ],
      stops: <double>[0.0, 0.25, 0.5, 0.75, 1.0],
    ),
    // ----------- Plan Text Styles -----------
    this.planCurrencyTextStyle,
    this.planNameTextStyle,
    this.planPriceTextStyle,
  });

  // ----------- Title & Description Styles -----------
  /// Main title text style.
  final TextStyle? titleStyle;
  /// Tab description text style.
  final TextStyle? textDescriptionStyle;

  // ----------- Subscription Tag Dimensions -----------
  /// Tag width.
  final double? tagSubscriptionWidth;
  /// Tag height.
  final double? tagSubscriptionHeight;

  // ----------- Plan Font Sizes -----------
  /// Currency font size.
  final double currencyFontSize;
  /// Price font size.
  final double priceFontSize;
  /// Plan title font size.
  final double titleFontSize;

  // ----------- Currency Flag -----------
  /// Currency flag height.
  final double currencyFlagHeight;
  /// Currency flag width.
  final double currencyFlagWidth;

  // ----------- Dropdown Styles -----------
  /// Dropdown content padding.
  final EdgeInsets? htmlDropdownContentPadding;
  /// Dropdown selector padding.
  final EdgeInsets? htmlDropdownSelectorPadding;
  /// Dropdown title text style.
  final TextStyle? htmlDropdownTitleTextStyle;

  // ----------- Information Message -----------
  /// Exclamation icon width.
  final double? exclamationIconWidth;
  /// Exclamation icon height.
  final double? exclamationIconHeight;
  /// Information message padding.
  final EdgeInsets? messageInformationPadding;
  /// Information message text style.
  final TextStyle? messageInformationTextStyle;

  // ----------- Action Button Paddings -----------
  /// Free trial button padding.
  final EdgeInsets? onTapFreeTrialPadding;
  /// Continue button padding.
  final EdgeInsets? onTapContinuePadding;
  /// Renew subscription button padding.
  final EdgeInsets? onTapRenewSubscriptionPadding;
  /// Cancel subscription button padding.
  final EdgeInsets? onTapCancelSubscriptionPadding;

  // ----------- Discount Message Style -----------
  /// Discount message text style.
  final TextStyle? planMessageDiscountTextStyle;

  // ----------- Tag Corner -----------
  /// Tag corner height.
  final double tagCornerHeight;
  /// Tag corner width.
  final double tagCornerWidth;
  /// Tag corner cut size.
  final double tagCornerCutSize;
  /// Tag corner radius.
  final double tagCornerRadius;
  /// Tag corner text padding.
  final EdgeInsets? tagCornerPaddingText;
  /// Tag corner text style.
  final TextStyle? tagCornerTextStyle;
  /// Tag corner background color.
  final Color tagCornerColor;
  /// Tag corner gradient border colors.
  final List<Color> tagCornerGradientColorsBorder;

  // ----------- Tag Gradient -----------
  /// Tag gradient height.
  final double tagGradientHeight;
  /// Tag gradient width.
  final double? tagGradientWidth;
  /// Tag gradient margin.
  final EdgeInsets? tagGradientMargin;
  /// Tag gradient padding.
  final EdgeInsets? tagGradientPadding;
  /// Tag gradient border radius.
  final double tagGradientBorderRadius;
  /// Tag gradient.
  final Gradient tagGradientGradient;
  /// Tag gradient title text style.
  final TextStyle? tagGradientTitleStyle;

  // ----------- Plan Text Styles -----------
  /// Plan currency text style.
  final TextStyle? planCurrencyTextStyle;
  /// Plan name text style.
  final TextStyle? planNameTextStyle;
  /// Plan price text style.
  final TextStyle? planPriceTextStyle;
  
}
