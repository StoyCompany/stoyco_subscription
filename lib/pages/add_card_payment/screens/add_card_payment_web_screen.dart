// add_card_payment_web_screen.dart
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/inputs/subscription_text_form.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/buttons/button_gradient_text.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/cards/card_gradient_multicheck.dart';
import 'package:stoyco_subscription/designs/atomic/organisms/cards/subscription_plan_payment_info_card.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/add_card_payment/enums/payment_card_type.dart';
import 'package:stoyco_subscription/pages/add_card_payment/notifier/add_card_payment_notifier.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/models/response/payment_symmary_info_response.dart';

/// {@template add_card_payment_web_screen}
/// Desktop/Tablet layout for the payment card addition screen.
///
/// This widget displays a two-column layout optimized for larger screens:
/// - Left column: Card preview and payment summary
/// - Right column: Form fields and action buttons
///
/// {@endtemplate}
class AddCardPaymentWebScreen extends StatelessWidget {
  /// Creates an [AddCardPaymentWebScreen].
  const AddCardPaymentWebScreen({
    super.key,
    required this.notifier,
    this.paymentSummaryInfo,
    required this.onTapTerms,
    required this.onTapPrivacy,
    required this.onTapAddCardPayment,
  });

  /// The notifier managing the form state.
  final AddCardPaymentNotifier notifier;

  /// Optional payment summary data model.
  final PaymentSummaryInfoResponse? paymentSummaryInfo;

  /// Callback to navigate to terms and conditions.
  final VoidCallback onTapTerms;

  /// Callback to navigate to privacy policy.
  final VoidCallback onTapPrivacy;

  /// Callback executed when the user submits the payment form.
  final Future<void> Function({
    required String cardHolderName,
    required String cardNumber,
    required String cardExpiry,
    required String cardCvv,
    required String seedDate,
    required bool isError,
    required String errorMessage,
  })
  onTapAddCardPayment;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: StoycoScreenSize.width(
            context,
            1200,
            desktop: 1200,
            desktopLarge: 1400,
          ),
        ),
        child: Padding(
          padding: StoycoScreenSize.symmetric(
            context,
            horizontal: 40,
            horizontalDesktop: 60,
            horizontalDesktopLarge: 80,
          ),
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
            children: <Widget>[
              Gap(StoycoScreenSize.height(context, 40, desktop: 60)),
              _buildTitleContent(context),
              Gap(StoycoScreenSize.height(context, 40, desktop: 60)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: StoycoScreenSize.width(context, 40, desktop: 60),
                children: <Widget>[
                  // Left column: Card preview and payment info
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        _buildPaymentInfoContent(context),
                        if (paymentSummaryInfo != null) ...<Widget>[
                          Gap(StoycoScreenSize.height(context, 32)),
                          SubscriptionPlanPaymentInfoCard(
                            paymentSummaryInfo: paymentSummaryInfo!,
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Right column: Form and actions
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        _buildFormContent(context),
                        Gap(StoycoScreenSize.height(context, 32)),
                        TermsPrivacyAutoRenewCard(
                          valueTerms: notifier.valueTerms,
                          valuePrivacy: notifier.valuePrivacy,
                          onChangedTerms: (bool? v) =>
                              notifier.onChangedTerms(v),
                          onChangedPrivacy: (bool? v) =>
                              notifier.onChangedPrivacy(v),
                          onTapTerms: onTapTerms,
                          onTapPrivacy: onTapPrivacy,
                        ),
                        Gap(StoycoScreenSize.height(context, 32)),
                        _buildButtonContent(context),
                      ],
                    ),
                  ),
                ],
              ),
              Gap(StoycoScreenSize.height(context, 40, desktop: 60)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Información de pago',
          style: TextStyle(
            color: StoycoColors.text,
            fontFamily: FontFamilyToken.akkuratPro,
            fontSize: StoycoScreenSize.fontSize(
              context,
              24,
              desktop: 32,
              desktopLarge: 36,
            ),
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          'Todas las transacciones son seguras y encriptadas',
          style: TextStyle(
            color: StoycoColors.text,
            fontFamily: FontFamilyToken.akkuratPro,
            fontSize: StoycoScreenSize.fontSize(
              context,
              16,
              desktop: 18,
              desktopLarge: 20,
            ),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInfoContent(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: StoycoScreenSize.width(
          context,
          343,
          desktop: 450,
          desktopLarge: 500,
        ),
        maxHeight: StoycoScreenSize.height(
          context,
          188,
          desktop: 246,
          desktopLarge: 274,
        ),
      ),
      child: Stack(
        children: <Widget>[
          StoycoAssets.lib.assets.images.payment.cardPayment.image(
            width: StoycoScreenSize.width(
              context,
              343,
              desktop: 450,
              desktopLarge: 500,
            ),
            height: StoycoScreenSize.height(
              context,
              188,
              desktop: 246,
              desktopLarge: 274,
            ),
            fit: BoxFit.contain,
            package: 'stoyco_subscription',
          ),
          Positioned(
            top: StoycoScreenSize.height(context, 8, desktop: 12),
            right: StoycoScreenSize.width(context, 46, desktop: 60),
            child: notifier.cardType == PaymentCardType.unknown
                ? const SizedBox.shrink()
                : Padding(
                    padding: StoycoScreenSize.fromLTRB(
                      context,
                      top: 17,
                      topDesktop: 22,
                    ),
                    child: SizedBox(
                      width: StoycoScreenSize.width(context, 70, desktop: 90),
                      height: StoycoScreenSize.height(context, 24, desktop: 32),
                      child: Center(
                        child: notifier.cardType.icon.endsWith('.svg')
                            ? SvgGenImage(notifier.cardType.icon).svg(
                                fit: BoxFit.contain,
                                width: StoycoScreenSize.width(
                                  context,
                                  40,
                                  desktop: 50,
                                ),
                                package: 'stoyco_subscription',
                              )
                            : AssetGenImage(notifier.cardType.icon).image(
                                fit: BoxFit.contain,
                                width: StoycoScreenSize.width(
                                  context,
                                  65,
                                  desktop: 85,
                                ),
                                package: 'stoyco_subscription',
                              ),
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: StoycoScreenSize.symmetric(
              context,
              horizontal: 48,
              horizontalDesktop: 60,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Gap(StoycoScreenSize.height(context, 52, desktop: 68)),
                Text(
                  notifier.maskedCardNumber(notifier.cardNumberController.text),
                  style: TextStyle(
                    fontFamily: FontFamilyToken.akkuratPro,
                    color: StoycoColors.text,
                    fontSize: StoycoScreenSize.fontSize(
                      context,
                      20,
                      desktop: 24,
                      desktopLarge: 26,
                    ),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gap(StoycoScreenSize.height(context, 33, desktop: 43)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Visibility(
                      replacement: SizedBox(
                        height: StoycoScreenSize.width(
                          context,
                          40,
                          desktop: 52,
                        ),
                      ),
                      visible:
                          notifier.cardHolderNameController.text.isNotEmpty,
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Nombre del titular',
                              style: TextStyle(
                                fontFamily: FontFamilyToken.akkuratPro,
                                color: StoycoColors.softWhite,
                                fontSize: StoycoScreenSize.fontSize(
                                  context,
                                  12,
                                  desktop: 14,
                                ),
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              notifier.cardHolderNameController.text,
                              style: TextStyle(
                                fontFamily: FontFamilyToken.akkuratPro,
                                color: StoycoColors.text,
                                fontSize: StoycoScreenSize.fontSize(
                                  context,
                                  14,
                                  desktop: 16,
                                ),
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: StoycoScreenSize.width(context, 10, desktop: 14),
                    ),
                    Visibility(
                      replacement: SizedBox(
                        height: StoycoScreenSize.width(
                          context,
                          40,
                          desktop: 52,
                        ),
                      ),
                      visible: notifier.cardExpiryController.text.isNotEmpty,
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Fecha vencimiento',
                                style: TextStyle(
                                  fontFamily: FontFamilyToken.akkuratPro,
                                  color: StoycoColors.softWhite,
                                  fontSize: StoycoScreenSize.fontSize(
                                    context,
                                    12,
                                    desktop: 14,
                                  ),
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                notifier.cardExpiryController.text,
                                style: TextStyle(
                                  fontFamily: FontFamilyToken.akkuratPro,
                                  color: StoycoColors.text,
                                  fontSize: StoycoScreenSize.fontSize(
                                    context,
                                    14,
                                    desktop: 16,
                                  ),
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContent(BuildContext context) {
    return Column(
      children: <Widget>[
        SubscriptionTextForm(
          controller: notifier.cardHolderNameController,
          focusNode: notifier.cardHolderNameFocusNode,
          keyboardType: TextInputType.text,
          hintText: 'Ingresar',
          labelText: 'Nombre del titular de la tarjeta',
          errorText: notifier.errorCardHolderName,
          onChanged: (String value) => notifier.onCardHolderNameChange(context),
        ),
        Gap(StoycoScreenSize.height(context, 16, desktop: 20)),
        SubscriptionTextForm(
          controller: notifier.cardNumberController,
          focusNode: notifier.cardNumberFocusNode,
          keyboardType: TextInputType.number,
          hintText: 'Ingresar',
          labelText: 'Número de tarjeta',
          errorText: notifier.errorCardNumber,
          onChanged: (String value) => notifier.onCardNumberChange(context),
        ),
        Gap(StoycoScreenSize.height(context, 16, desktop: 20)),
        Row(
          spacing: StoycoScreenSize.width(context, 16, desktop: 20),
          children: <Widget>[
            Expanded(
              child: SubscriptionTextForm(
                controller: notifier.cardExpiryController,
                focusNode: notifier.cardExpiryFocusNode,
                keyboardType: TextInputType.number,
                hintText: 'MM/AA',
                labelText: 'Fecha de vencimiento',
                errorText: notifier.errorCardExpiry,
                onChanged: (String value) =>
                    notifier.onCardExpiryChange(context),
              ),
            ),
            Expanded(
              child: SubscriptionTextForm(
                controller: notifier.cardCvvController,
                focusNode: notifier.cardCvvFocusNode,
                keyboardType: TextInputType.number,
                hintText: 'Ingresar',
                labelText: 'CVV',
                errorText: notifier.errorCardCvv,
                onChanged: (String value) => notifier.onCardCvvChange(context),
                suffixIcon: Padding(
                  padding: StoycoScreenSize.fromLTRB(
                    context,
                    right: 16,
                    bottom: 14,
                    top: 14,
                  ),
                  child: SizedBox(
                    width: StoycoScreenSize.width(context, 14),
                    height: StoycoScreenSize.width(context, 14),
                    child: StoycoAssets.lib.assets.icons.payment.cardCvv.svg(
                      fit: BoxFit.contain,
                      package: 'stoyco_subscription',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    return ButtonGradientText(
      text: 'Siguiente',
      iconPosition: ButtonGradientTextIconPosition.right,
      iconWidget: StoycoAssets.lib.assets.icons.common.rightArrow.svg(
        package: 'stoyco_subscription',
      ),
      type: notifier.isDisabled
          ? ButtonGradientTextType.inactive
          : notifier.isLoading
          ? ButtonGradientTextType.loading
          : ButtonGradientTextType.primary,
      onPressed: notifier.isDisabled
          ? null
          : () async {
              notifier.toggleLoading();
              final String cardHolderName = notifier
                  .cardHolderNameController
                  .text
                  .trim();
              final String cardNumber = notifier.cardNumberController.text
                  .replaceAll(' ', '');
              final String cardExpiry = notifier.cardExpiryController.text
                  .replaceAll('/', '');
              final String cardCvv = notifier.cardCvvController.text;
              final String seedDate = notifier.getSeedDate();
              final String? errorMessage =
                  notifier.errorCardCvv ??
                  notifier.errorCardExpiry ??
                  notifier.errorCardNumber ??
                  notifier.errorCardHolderName;
              await onTapAddCardPayment(
                cardHolderName: cardHolderName,
                cardNumber: cardNumber,
                cardExpiry: cardExpiry,
                cardCvv: cardCvv,
                seedDate: seedDate,
                isError: errorMessage != null,
                errorMessage: errorMessage ?? 'No hay errores.',
              );
              notifier.toggleLoading();
              notifier.validateIsDisabled();
            },
    );
  }
}
