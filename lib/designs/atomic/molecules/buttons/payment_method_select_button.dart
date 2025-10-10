import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/models/payment_card_type.dart';

class PaymentMethodSelectButton extends StatefulWidget {
  const PaymentMethodSelectButton({
    required this.lastDigits,
    required this.cardType,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  final String lastDigits;
  final PaymentCardType cardType;
  final bool isSelected;
  final Function onTap;
  final Function onDelete;

  @override
  PaymentItemCardState createState() => PaymentItemCardState();
}

class PaymentItemCardState extends State<PaymentMethodSelectButton> {
  bool isDraggingLeft = false;

  @override
  Widget build(BuildContext context) {
    final String cardNumber = '•••• •••• •••• ${widget.lastDigits}';
    final String svgSelectedCard = widget.isSelected
        ? 'lib/assets/icons/radio_buttons/Radiobuttons_selected.svg'
        : 'lib/assets/icons/radio_buttons/Radiobuttons_no_selected.svg';

    return GestureDetector(
      onTap: () => widget.onTap(),
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
          setState(() {
            isDraggingLeft = true;
          });
        }
      },
      onHorizontalDragCancel: () {
        setState(() {
          isDraggingLeft = false;
        });
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (details.primaryDelta != null && details.primaryDelta! < -50) {
          setState(() {
            isDraggingLeft = true;
          });
        } else {
          setState(() {
            isDraggingLeft = false;
          });
        }
      },
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 8, top: 8),
            decoration: const BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Color(0xFF10141C),
                  offset: Offset(0, 20),
                  blurRadius: 30,
                ),
                BoxShadow(
                  color: Color(0x2B344580),
                  offset: Offset(0, -20),
                  blurRadius: 30,
                ),
              ],
            ),
            child: GlassmorphicContainer(
              width: double.infinity,
              height: 56,
              blur: 0,
              border: 1,
              borderGradient: const LinearGradient(
                colors: <Color>[
                  Color.fromRGBO(255, 255, 255, 0.25),
                  Color.fromRGBO(0, 0, 0, 0.25),
                  Color.fromRGBO(0, 0, 0, 0.25),
                ],
                stops: <double>[0.0751, 0.5643, 0.6543],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: 16,
              linearGradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Color(0xFF283444), Color(0xFF1E262F)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(left: 24),
                    child: Center(
                      child: () {
                        if (widget.cardType.icon.contains('.svg')) {
                          return SvgPicture.asset(widget.cardType.icon);
                        } else {
                          return Image.asset(widget.cardType.icon, width: 45);
                        }
                      }(),
                    ),
                  ),
                  Center(
                    child: Text(
                      cardNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 24),
                    child: Center(child: SvgPicture.asset(svgSelectedCard)),
                  ),
                ],
              ),
            ),
          ),
          // Delete Button
          Positioned(
            top: 8.5,
            right: 0,
            child: GestureDetector(
              onTap: () => widget.onDelete(),
              child: AnimatedContainer(
                width: isDraggingLeft ? 56 : 0,
                height: 56,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFE74C3C),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: AnimatedOpacity(
                  opacity: isDraggingLeft ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
