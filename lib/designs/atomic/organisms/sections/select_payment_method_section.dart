import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/buttons/payment_method_option_btn.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/models/payment_method_model.dart';

/// {@template select_payment_method_section}
/// A [SelectPaymentMethodSection] organism for the Book Stack Atomic Design System.
///
/// ### Overview
/// Displays a section for selecting a payment method, including a list of available payment methods and options to add a new card or use Apple Pay. Designed for use in payment or checkout flows.
///
/// ### Atomic Level
/// **Organism** – Composed of molecules and atoms (buttons, lists, icons) for payment method selection.
///
/// ### Parameters
/// - `paymentMethodList`: The list of available payment methods to display (optional).
/// - `key`: Optional widget key.
///
/// ### Returns
/// Renders a column with a title, selectable payment method list, and action buttons for adding new payment methods or using Apple Pay.
///
/// ### Example
/// ```dart
/// SelectPaymentMethodSection(
///   paymentMethodList: myPaymentMethods,
/// )
/// ```
/// {@endtemplate}
class SelectPaymentMethodSection extends StatelessWidget {
  /// {@macro select_payment_method_section}
  const SelectPaymentMethodSection({super.key, this.paymentMethodList});

  /// The list of available payment methods to display (optional).
  final List<PaymentMethodModel>? paymentMethodList;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: StoycoScreenSize.height(context, 16),
      children: <Widget>[
        Text(
          'Selecciona método de pago',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: StoycoColors.text,
              fontSize: StoycoScreenSize.fontSize(context, 16),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        //* Added selectable payment method's list
        (paymentMethodList == null || paymentMethodList!.isEmpty)
            ? const SizedBox.shrink()
            : ListView.builder(
                itemCount: paymentMethodList?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return null;
                  //Todo: add selectable payment method button
                },
              ),

        //* Payment options
        PaymentMethodOptionBtn(
          onTap: () {
            //Todo: navigate to Add Payment Method Page
          },
          icon: StoycoAssets.lib.assets.icons.plusIcon.svg(
            width: StoycoScreenSize.width(context, 24),
            height: StoycoScreenSize.height(context, 24),
            package: 'stoyco_subscription',
          ),
          text: 'Agregar nueva tarjeta',
        ),
        PaymentMethodOptionBtn(
          onTap: () {
            //Todo: start Apple Pay flow
          },
          icon: StoycoAssets.lib.assets.icons.appleLogo.svg(
            width: StoycoScreenSize.width(context, 24),
            height: StoycoScreenSize.height(context, 24),
            package: 'stoyco_subscription',
          ),
          text: 'Apple Pay',
        ),
      ],
    );
  }
}
