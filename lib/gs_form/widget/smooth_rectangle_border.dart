import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class SmoothBorderRadius {
  final double cornerRadius;
  final double cornerSmoothing;

  const SmoothBorderRadius({
    required this.cornerRadius,
    this.cornerSmoothing = 0.6,
  }) : assert(cornerSmoothing >= 0 && cornerSmoothing <= 1);

  Path toPacth(Rect rect) {
    final path = Path();
    if (cornerRadius <= 0) {
      path.addRect(rect);
      return path;
    }

    final smoothness = cornerSmoothing * 0.5;
    final radius = math.min(
      cornerRadius,
      math.min(rect.width / 2, rect.height / 2),
    );

    final controlPoint = radius - (radius * smoothness);

    // 开始绘制路径
    path.moveTo(rect.left, rect.top + radius);

    // 左上角
    path.cubicTo(
      rect.left,
      rect.top + controlPoint,
      rect.left + controlPoint,
      rect.top,
      rect.left + radius,
      rect.top,
    );

    // 顶边
    path.lineTo(rect.right - radius, rect.top);

    // 右上角
    path.cubicTo(
      rect.right - controlPoint,
      rect.top,
      rect.right,
      rect.top + controlPoint,
      rect.right,
      rect.top + radius,
    );

    // 右边
    path.lineTo(rect.right, rect.bottom - radius);

    // 右下角
    path.cubicTo(
      rect.right,
      rect.bottom - controlPoint,
      rect.right - controlPoint,
      rect.bottom,
      rect.right - radius,
      rect.bottom,
    );

    // 底边
    path.lineTo(rect.left + radius, rect.bottom);

    // 左下角
    path.cubicTo(
      rect.left + controlPoint,
      rect.bottom,
      rect.left,
      rect.bottom - controlPoint,
      rect.left,
      rect.bottom - radius,
    );

    // 闭合路径
    path.close();
    return path;
  }
}

class SmoothRectangleBorder extends ShapeBorder {
  final BorderSide side;
  final SmoothBorderRadius borderRadius;

  const SmoothRectangleBorder({
    this.side = BorderSide.none,
    required this.borderRadius,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final adjustedRect = rect.deflate(side.width);
    return borderRadius.toPacth(adjustedRect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return borderRadius.toPacth(rect);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.width <= 0) return;

    final paint = side.toPaint();
    final path = getOuterPath(rect, textDirection: textDirection);
    canvas.drawPath(path, paint);
  }

  @override
  ShapeBorder scale(double t) {
    return SmoothRectangleBorder(
      side: side.scale(t),
      borderRadius: borderRadius,
    );
  }

  @override
  SmoothRectangleBorder copyWith({
    BorderSide? side,
    SmoothBorderRadius? borderRadius,
  }) {
    return SmoothRectangleBorder(
      side: side ?? this.side,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }
}