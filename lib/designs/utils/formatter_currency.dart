String formatPrice(double price) {
  if (price == price.roundToDouble()) {
    return price.toStringAsFixed(0);
  }
  return price.toStringAsFixed(2);
}
