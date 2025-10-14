import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/models/payment_card_type.dart';

/// {@template payment_method_select_button}
/// A widget that displays a selectable payment method card with swipe-to-delete functionality.
///
/// This widget shows the card type icon, masked card number, and a radio button indicating selection.
/// Users can tap to select the card or swipe left to reveal a delete action. The delete button can also be tapped directly.
///
/// Example usage:
/// ```dart
/// PaymentMethodSelectButton(
///   lastDigits: '1234',
///   cardType: PaymentCardType.visa,
///   isSelected: true,
///   onTap: () { /* select card */ },
///   onDelete: () { /* delete card */ },
/// )
/// ```
/// {@endtemplate}
class PaymentMethodSelectButton extends StatefulWidget {
  /// Creates a [PaymentMethodSelectButton].
  ///
  /// [lastDigits] is the last four digits of the card number.
  /// [cardType] is the type of the payment card.
  /// [isSelected] indicates if this card is currently selected.
  /// [onTap] is called when the card is tapped.
  /// [onDelete] is called when the card is deleted (swiped or delete button tapped).
  const PaymentMethodSelectButton({
    required this.lastDigits,
    required this.cardType,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  /// The last four digits of the card number.
  final String lastDigits;

  /// The type of the payment card.
  final PaymentCardType cardType;

  /// Whether this card is currently selected.
  final bool isSelected;

  /// Callback when the card is tapped.
  final Function onTap;

  /// Callback when the card is deleted.
  final Function onDelete;

  @override
  PaymentItemCardState createState() => PaymentItemCardState();
}

/// State for [PaymentMethodSelectButton].
class PaymentItemCardState extends State<PaymentMethodSelectButton> {
  /// Controls the dragging state for showing the delete button.
  final ValueNotifier<bool> isDraggingLeft = ValueNotifier<bool>(false);

  @override
  void dispose() {
    isDraggingLeft.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String cardNumber = '•••• •••• •••• ${widget.lastDigits}';
    final String svgSelectedCard = widget.isSelected
        ? StoycoAssets.lib.assets.icons.radiobuttonsSelected.path
        : StoycoAssets.lib.assets.icons.radiobuttonsNoSelected.path;

    return Dismissible(
      key: ValueKey<String>(widget.lastDigits),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: const Color(0xFFE74C3C),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => widget.onDelete(),
      child: GestureDetector(
        onTap: () => widget.onTap(),
        onHorizontalDragEnd: (DragEndDetails details) {
          if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
            isDraggingLeft.value = true;
          }
        },
        onHorizontalDragCancel: () {
          isDraggingLeft.value = false;
        },
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          if (details.primaryDelta != null && details.primaryDelta! < -50) {
            isDraggingLeft.value = true;
          } else {
            isDraggingLeft.value = false;
          }
        },
        child: Stack(
          children: <Widget>[
            Container(
              margin: StoycoScreenSize.symmetric(context, vertical: 8),
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
                height: StoycoScreenSize.height(context, 56),
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
                borderRadius: StoycoScreenSize.radius(context, 16),
                linearGradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Color(0xFF283444), Color(0xFF1E262F)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: StoycoScreenSize.fromLTRB(context, left: 24),
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
                child: ValueListenableBuilder<bool>(
                  valueListenable: isDraggingLeft,
                  builder: (context, dragging, child) {
                    return AnimatedContainer(
                      width: dragging ? 56 : 0,
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
                        opacity: dragging ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
