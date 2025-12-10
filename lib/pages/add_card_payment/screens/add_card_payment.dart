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

/// {@template add_card_payment}
/// An [AddCardPayment] Page for the Stoyco Subscription Atomic Design System.
/// Displays a complete payment form for adding a card, including payment summary, card details, terms acceptance, and submit button.
///
/// ### Atomic Level
/// **Page** – Composed of molecules and atoms for complex payment flow integration.
///
/// ### Parameters
/// - `paymentSummaryInfo`: Optional payment summary data model for displaying plan/payment info.
/// - `onTapTerms`: Callback to navigate to terms and conditions.
/// - `onTapPrivacy`: Callback to navigate to privacy policy.
/// - `onTapAddCardPayment`: Callback executed when the user submits the payment form.
///
/// ### Returns
/// Renders a scrollable payment form with card details, summary, terms acceptance, and a submit button.
///
/// ### Example
/// ```dart
/// AddCardPayment(
///   paymentSummaryInfo: paymentSummaryInfo,
///   onTapTerms: () {},
///   onTapPrivacy: () {},
///   onTapAddCardPayment: ({
///     required cardHolderName,
///     required cardNumber,
///     required cardExpiry,
///     required cardCvv,
///     required seedDate,
///     required isError,
///     required errorMessage,
///   }) async {},
/// )
/// ```
/// {@endtemplate}

/// {@macro add_card_payment}
class AddCardPayment extends StatefulWidget {
  /// Creates an [AddCardPayment] Page for the Stoyco Subscription Design System.
  ///
  /// - [paymentSummaryInfo]: Optional payment summary data model for displaying plan/payment info.
  /// - [onTapTerms]: Callback to navigate to terms and conditions.
  /// - [onTapPrivacy]: Callback to navigate to privacy policy.
  /// - [onTapAddCardPayment]: Callback executed when the user submits the payment form.
  const AddCardPayment({
    super.key,
    this.paymentSummaryInfo,
    required this.onTapTerms,
    required this.onTapPrivacy, 
    required this.onTapAddCardPayment,
  });

  /// Optional payment summary data model for displaying plan/payment info.
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
  }) onTapAddCardPayment;

  @override
  State<AddCardPayment> createState() => _AddCardPaymentState();
}

class _AddCardPaymentState extends State<AddCardPayment> {

  late final AddCardPaymentNotifier notifier;
  late final FocusNode cardHolderNameFocusNode;
  late final FocusNode cardNumberFocusNode;
  late final FocusNode cardExpiryFocusNode;
  late final FocusNode cardCvvFocusNode;

  @override
  void initState() {
    super.initState();
    cardHolderNameFocusNode = FocusNode();
    cardNumberFocusNode = FocusNode();
    cardExpiryFocusNode = FocusNode();
    cardCvvFocusNode = FocusNode();
    notifier = AddCardPaymentNotifier(
      cardHolderNameFocusNode: cardHolderNameFocusNode,
      cardNumberFocusNode: cardNumberFocusNode,
      cardExpiryFocusNode: cardExpiryFocusNode,
      cardCvvFocusNode: cardCvvFocusNode,
    );
    notifier.addListener(_onNotifierChanged);
  }

  @override
  void dispose() {
    notifier.removeListener(_onNotifierChanged);
    notifier.cardNumberController.dispose();
    notifier.cardExpiryController.dispose();
    notifier.cardCvvController.dispose();
    cardHolderNameFocusNode.dispose();
    cardNumberFocusNode.dispose();
    cardExpiryFocusNode.dispose();
    cardCvvFocusNode.dispose();
    super.dispose();
  }

  void _onNotifierChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: StoycoScreenSize.symmetric(context, horizontal: 24),
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        children: <Widget>[
          _buildTitleContent(),
          Gap(StoycoScreenSize.height(context, 40)),
          _buildPaymentInfoContent(),
          Gap(StoycoScreenSize.height(context, 40)),
          _buildFormContent(),
          if (widget.paymentSummaryInfo != null) ...<Widget>[
            Gap(StoycoScreenSize.height(context, 40)),
            SubscriptionPlanPaymentInfoCard(
              paymentSummaryInfo: widget.paymentSummaryInfo!,
            ),
          ],
          Gap(StoycoScreenSize.height(context, 40)),
          TermsPrivacyAutoRenewCard(
            valueTerms: notifier.valueTerms,
            valuePrivacy: notifier.valuePrivacy,
            onChangedTerms: (bool? v) => notifier.onChangedTerms(v),
            onChangedPrivacy: (bool? v) => notifier.onChangedPrivacy(v),
            onTapTerms: widget.onTapTerms,
            onTapPrivacy: widget.onTapPrivacy,
          ),
          Gap(StoycoScreenSize.height(context, 40)),
          _buildButtonContent(),
          Gap(StoycoScreenSize.height(context, 40)),
        ],
      ),
    );
  }

  Widget _buildTitleContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Información de pago',
          style: TextStyle(
            color: StoycoColors.text,
            fontFamily: FontFamilyToken.akkuratPro,
            fontSize: StoycoScreenSize.fontSize(context, 24),
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          'Todas las transacciones son seguras y encriptadas',
          style: TextStyle(
              color: StoycoColors.text,
              fontFamily: FontFamilyToken.akkuratPro,
              fontSize: StoycoScreenSize.fontSize(context, 16),
              fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  } 

  Widget _buildPaymentInfoContent() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: StoycoScreenSize.width(context, 343),
        maxHeight: StoycoScreenSize.height(context, 188),
      ),
      child: Stack(
        children: <Widget>[
          StoycoAssets.lib.assets.images.payment.cardPayment.image(
            width: StoycoScreenSize.width(context, 343),
            height: StoycoScreenSize.height(context, 188),
            fit: BoxFit.contain,
            package: 'stoyco_subscription',
          ),
          Positioned(
            top: StoycoScreenSize.height(context, 8),
            right: StoycoScreenSize.width(context, 46),
            child: notifier.cardType == PaymentCardType.unknown
                ? const SizedBox.shrink()
                : Padding(
                    padding: StoycoScreenSize.fromLTRB(context, top: 17),
                    child: SizedBox(
                      width: StoycoScreenSize.width(context, 70),
                      height: StoycoScreenSize.height(context, 24),
                      child: Center(
                        child: notifier.cardType.icon.endsWith('.svg')
                            ? SvgGenImage(notifier.cardType.icon).svg(
                                fit: BoxFit.contain,
                                width: StoycoScreenSize.width(context, 40),
                                package: 'stoyco_subscription',
                              )
                            : AssetGenImage(notifier.cardType.icon).image(
                                fit: BoxFit.contain,
                                width: StoycoScreenSize.width(context, 65),
                                package: 'stoyco_subscription',
                              ),
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: StoycoScreenSize.symmetric(context, horizontal: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Gap(StoycoScreenSize.height(context, 52)),
                Text(
                  notifier.maskedCardNumber(
                    notifier.cardNumberController.text,
                  ),
                  style: TextStyle(
                      fontFamily: FontFamilyToken.akkuratPro,
                      color: StoycoColors.text,
                      fontSize: StoycoScreenSize.fontSize(
                        context,
                        20,
                      ),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gap(StoycoScreenSize.height(context, 33)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Visibility(
                      replacement: SizedBox(
                        height: StoycoScreenSize.width(context, 40),
                      ),
                      visible: notifier.cardHolderNameController.text.isNotEmpty,
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Nombre del titular',
                              style: TextStyle(
                                  fontFamily: FontFamilyToken.akkuratPro,
                                  color: StoycoColors.softWhite,
                                  fontSize: StoycoScreenSize.fontSize(context, 12),
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
                                  fontSize: StoycoScreenSize.fontSize(context, 14),
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
                      width: StoycoScreenSize.width(context, 10),
                    ),
                    Visibility(
                      replacement: SizedBox(
                        height: StoycoScreenSize.width(context, 40),
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
                                    fontSize: StoycoScreenSize.fontSize(context, 12),
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
                                    fontSize: StoycoScreenSize.fontSize(context, 14),
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

  Widget _buildFormContent() {
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
        Gap(StoycoScreenSize.height(context, 16)),
        SubscriptionTextForm(
          controller: notifier.cardNumberController,
          focusNode: notifier.cardNumberFocusNode,
          keyboardType: TextInputType.number,
          hintText: 'Ingresar',
          labelText: 'Número de tarjeta',
          errorText: notifier.errorCardNumber,
          onChanged: (String value) => notifier.onCardNumberChange(context),
        ),
        Gap(StoycoScreenSize.height(context, 16)),
        SubscriptionTextForm(
          controller: notifier.cardExpiryController,
          focusNode: notifier.cardExpiryFocusNode,
          keyboardType: TextInputType.number,
          hintText: 'MM/AA',
          labelText: 'Fecha de vencimiento',
          errorText: notifier.errorCardExpiry,
          onChanged: (String value) => notifier.onCardExpiryChange(context),
        ),
        Gap(StoycoScreenSize.height(context, 16)),
        SubscriptionTextForm(
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
      ],
    );
  }

  Widget _buildButtonContent() {
    return ButtonGradientText(
      text: 'Siguiente',
      iconPosition: ButtonGradientTextIconPosition.right,
      iconWidget: StoycoAssets.lib.assets.icons.common.rightArrow.svg(
        package: 'stoyco_subscription',
      ),
      type: notifier.isDisabled ? ButtonGradientTextType.inactive : notifier.isLoading ? ButtonGradientTextType.loading : ButtonGradientTextType.primary,
      onPressed: notifier.isDisabled
          ? null
          : () async {
              notifier.toggleLoading();
              final String cardHolderName = notifier.cardHolderNameController.text.trim();
              final String cardNumber = notifier.cardNumberController.text.replaceAll(' ', '');
              final String cardExpiry = notifier.cardExpiryController.text.replaceAll('/', '');
              final String cardCvv = notifier.cardCvvController.text;
              final String seedDate = notifier.getSeedDate();
              final String? errorMessage = notifier.errorCardCvv ?? notifier.errorCardExpiry ?? notifier.errorCardNumber ?? notifier.errorCardHolderName;
              await widget.onTapAddCardPayment(
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
