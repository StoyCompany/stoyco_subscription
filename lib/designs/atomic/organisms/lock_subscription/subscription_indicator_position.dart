class SubscriptionIndicatorPosition {
  const SubscriptionIndicatorPosition({
    this.left,
    this.right,
    this.top,
    this.bottom,
  }) : assert(
         (left != null && right == null) ||
             (left == null && right != null) ||
             (left == null && right == null),
         'Cannot provide both left and right positions',
       ),
       assert(
         (top != null && bottom == null) ||
             (top == null && bottom != null) ||
             (top == null && bottom == null),
         'Cannot provide both top and bottom positions',
       );

  /// Distance from the left edge. If null, uses [right] or defaults to 8
  final double? left;

  /// Distance from the right edge. If null and [left] is null, no horizontal positioning is applied
  final double? right;

  /// Distance from the top edge. If null, uses [bottom] or defaults to 25
  final double? top;

  /// Distance from the bottom edge. If null and [top] is null, no vertical positioning is applied
  final double? bottom;

  /// Default position: left: 8, top: 25
  static const SubscriptionIndicatorPosition defaultPosition =
      SubscriptionIndicatorPosition(left: 8, top: 25);
}
