import 'dart:collection';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/types/tag_corner_position.dart';

/// Returns the points for the selected corner position.
List<Offset> getTagCornerPolygonPoints(Rect rect, TagCornerPosition position) {
  switch (position) {
    case TagCornerPosition.topRight:
      return <Offset>[rect.topLeft, rect.bottomRight, rect.topRight];
    case TagCornerPosition.topLeft:
      return <Offset>[rect.topRight, rect.bottomLeft, rect.topLeft];
    case TagCornerPosition.bottomRight:
      return <Offset>[rect.bottomLeft, rect.topRight, rect.bottomRight];
    case TagCornerPosition.bottomLeft:
      return <Offset>[rect.bottomRight, rect.topLeft, rect.bottomLeft];
  }
}

/// Returns the radii for the polygon corners.
List<double> getTagCornerPolygonRadii(double cornerRadius) => <double>[0, 0, cornerRadius];

/// Returns the rotation angle for the text based on the corner position.
double getTagCornerTextRotation(TagCornerPosition position) {
  switch (position) {
    case TagCornerPosition.topRight:
      return 0.7854; // 45°
    case TagCornerPosition.topLeft:
      return -0.7854; // -45°
    case TagCornerPosition.bottomRight:
      return -0.7854; // -45°
    case TagCornerPosition.bottomLeft:
      return 0.7854; // 45°
  }
}

/// {@template path_builder}
/// Signature for a function that builds a custom [Path] for a polygon border.
///
/// Used by [PathBuilderBorder] to generate the shape for a widget.
/// The [bounds] parameter provides the rectangle in which the path should fit.
/// The [phase] parameter can be used for morphing or animation.
///
/// Example:
/// ```dart
/// PathBuilder builder = (Rect bounds, double phase) {
///   return roundPolygon(
///     points: [bounds.topLeft, bounds.topRight, bounds.bottomRight, bounds.bottomLeft],
///     radius: 16,
///   );
/// };
/// ```
/// {@endtemplate}
typedef PathBuilder = Path Function(Rect bounds, double phase);

/// Generates a [Path] for a polygon with rounded corners.
///
/// [points] specifies the vertices of the polygon in order.
/// [radii] specifies the corner radius for each vertex (must match points length).
/// [radius] specifies a uniform radius for all corners (if [radii] is not provided).
///
/// Returns a closed [Path] representing the rounded polygon.
///
/// Example:
/// ```dart
/// Path path = roundPolygon(
///   points: [Offset(0,0), Offset(100,0), Offset(100,100), Offset(0,100)],
///   radius: 16,
/// );
/// ```
Path roundPolygon({
  required List<Offset> points,
  List<double>? radii,
  double? radius,
}) {
  assert(
    (radii == null) ^ (radius == null),
  'You must specify either radii or radius, but not both.'
  );
  assert(
    radii == null || radii.length == points.length,
    'If radii is specified, its length must match the number of points.'
  );
  radii ??= List<double>.filled(points.length, radius!);

  // Convert relative offsets to absolute positions if needed.
  final List<Offset> absolutePoints;
  if (!points.any((ui.Offset point) => point is _RelativeOffset)) {
    absolutePoints = points;
  } else {
    Offset prevPoint = Offset.zero;
    absolutePoints = points.map((ui.Offset point) {
      return prevPoint = point is _RelativeOffset? prevPoint + point : point;
    }).toList();
  }

  // Make the list cyclic for polygon calculations.
  final List<ui.Offset> p = absolutePoints.cycled();

  // Calculate direction of each edge.
  final List<double> directions = p.mapIndexed((int index, ui.Offset point) {
    final ui.Offset delta = p[index + 1] - point;
    assert(delta != Offset.zero, 'Any two adjacent points must be different');
    return delta.direction;
  }).toList().cycled();

  // Calculate angle at each vertex.
  final List<double> angles = p.mapIndexed((int index, ui.Offset point) {
    final ui.Offset nextDelta = p[index + 1] - point;
    final ui.Offset prevDelta = p[index - 1] - point;
    final double angle = prevDelta.direction - nextDelta.direction;
    assert(radii![index] == 0 || angle != 0);
    return angle;
  }).toList();

  // Calculate distance for each rounded corner.
  final Iterable<double> distances = angles.mapIndexed((int i, double a) {
    return radii![i] / sin(a / 2);
  });

  final ui.Path path = Path();
  int i = 0;
  for (final double distance in distances) {
    if (radii[i] != 0) {
      final double direction = directions[i] + angles[i] / 2;
      final double normalizedAngle = angles[i] % (2 * pi);
      final ui.Offset center = p[i] + Offset.fromDirection(direction, normalizedAngle < pi? distance : -distance);

      final ui.Rect rect = Rect.fromCircle(center: center, radius: radii[i]);
      final double startAngle = directions[i - 1] + (normalizedAngle < pi? 1.5 * pi : -1.5 * pi);
      final double sweepAngle = (normalizedAngle < pi? pi : -pi) - angles[i];

      path.arcTo(rect, startAngle, sweepAngle, i == 0);
    } else {
      i == 0?
        path.moveTo(p[i].dx, p[i].dy) :
        path.lineTo(p[i].dx, p[i].dy);
    }
    i++;
  }
  return path..close();
}

/// Extension to create a relative offset for polygon path calculations.
extension RelativeOffsetExtension on Offset {
  /// Returns a [_RelativeOffset] representing a relative offset.
  Offset get relative => _RelativeOffset(dx, dy);
}

/// Internal class for relative offset representation.
class _RelativeOffset extends Offset {
  _RelativeOffset(super.dx, super.dy);
}

/// Signature for a callback that paints a custom frame on a [Canvas].
///
/// Used by [PathBuilderBorder] to allow custom painting before or after the border is drawn.
/// The [canvas] parameter provides the drawing surface.
/// The [bounds] parameter provides the rectangle in which to paint.
/// The [phase] parameter can be used for morphing or animation.
typedef OnPaintFrame = void Function(Canvas canvas, ui.Rect bounds, double phase);

/// A custom [OutlinedBorder] that uses a [PathBuilder] to define its shape.
///
/// Supports morphing/animation via the [phase] parameter and custom painting
/// before/after the border via [painter] and [foregroundPainter].
class PathBuilderBorder extends OutlinedBorder {
  /// Creates a [PathBuilderBorder].
  ///
  /// [pathBuilder] defines the polygon shape.
  /// [side] specifies the border style.
  /// [phase] can be used for morphing/animation.
  /// [painter] paints before the border, [foregroundPainter] after.
  const PathBuilderBorder({
    required this.pathBuilder,
    super.side,
    this.phase = 0,
    this.painter,
    this.foregroundPainter,
  });

  /// The function that builds the polygon path.
  final PathBuilder pathBuilder;
  /// The morph/animation phase.
  final double phase;
  /// Custom painter before border.
  final OnPaintFrame? painter;
  /// Custom painter after border.
  final OnPaintFrame? foregroundPainter;

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is PathBuilderBorder && phase != a.phase) {
      return PathBuilderBorder(
        pathBuilder: pathBuilder,
        side: side == a.side? side : BorderSide.lerp(a.side, side, t),
        phase: ui.lerpDouble(a.phase, phase, t)!,
        painter: painter,
        foregroundPainter: foregroundPainter,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  ui.Path getInnerPath(ui.Rect rect, {ui.TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  ui.Path getOuterPath(ui.Rect rect, {ui.TextDirection? textDirection}) {
    return pathBuilder(rect, phase);
  }

  @override
  void paint(ui.Canvas canvas, ui.Rect rect, {ui.TextDirection? textDirection}) {
    painter?.call(canvas, rect, phase);
    if (side != BorderSide.none) {
      canvas.drawPath(pathBuilder(rect, phase), side.toPaint());
    }
    foregroundPainter?.call(canvas, rect, phase);
  }

  @override
  ShapeBorder scale(double t) => this;

  @override
  OutlinedBorder copyWith({BorderSide? side}) {
    return PathBuilderBorder(
      pathBuilder: pathBuilder,
      side: side ?? this.side,
      phase: phase,
      painter: painter,
      foregroundPainter: foregroundPainter,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is PathBuilderBorder &&
      other.phase == phase;
  }

  @override
  int get hashCode => phase.hashCode;
}

/// Extension to make a list cyclic, so indexing wraps around.
extension _CyclicListExtension<T> on List<T> {
  /// Returns a cyclic list wrapper for this list.
  List<T> cycled() => _CyclicList<T>(this);
}

/// Internal cyclic list implementation.
class _CyclicList<T> with ListMixin<T> {
  _CyclicList(this.list);

  final List<T> list;

  @override
  int get length => list.length;

  @override
  set length(int newLength) => throw UnsupportedError('Setting length is not supported for cyclic lists.');

  @override
  T operator [](int index) => list[index % list.length];

  @override
  void operator []=(int index, T value) => throw UnsupportedError('Indexed assignment is not supported for cyclic lists.');
}
