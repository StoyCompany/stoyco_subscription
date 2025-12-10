import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

class PaymentInformationSection extends StatelessWidget {
  const PaymentInformationSection({super.key, required this.items});
  final List<Map<String, String>> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(items.length * 2, (int index) {
        if (index.isOdd) {
          return const Divider(color: StoycoColors.hint, height: 1);
        }
        final Map<String, String> item = items[index ~/ 2];
        return Padding(
          padding: StoycoScreenSize.symmetric(context, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                item['key'] ?? '',
                style: TextStyle(
                    fontFamily: FontFamilyToken.akkuratPro,
                    color: StoycoColors.softWhite,
                    fontWeight: FontWeight.w700,
                    fontSize: StoycoScreenSize.fontSize(context, 16),
                ),
              ),
              Text(
                item['value'] ?? '',
                style: TextStyle(
                    fontFamily: FontFamilyToken.akkuratPro,
                    color: StoycoColors.softWhite,
                    fontWeight: FontWeight.w700,
                    fontSize: StoycoScreenSize.fontSize(context, 16),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
