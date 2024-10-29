import 'package:flutter/material.dart';
import 'dart:math' as math;

class Timeline extends StatelessWidget {
  const Timeline({
    Key? key,
    required this.children,
    required this.indicators,
    this.isLeftAligned = true,
    this.itemGap = 12.0,
    this.gutterSpacing = 4.0,
    this.padding = const EdgeInsets.all(8),
    this.controller,
    this.lineColor = Colors.grey,
    this.physics,
    this.shrinkWrap = true,
    this.primary = false,
    this.reverse = false,
    this.indicatorSize = 30.0,
    this.lineGap = 0.0,
    this.indicatorColor = Colors.blue,
    this.indicatorStyle = PaintingStyle.fill,
    this.strokeCap = StrokeCap.butt,
    this.strokeWidth = 2.0,
    this.style = PaintingStyle.stroke,
    required this.hideIndicator,
  })  : itemCount = children.length,
        assert(itemGap >= 0),
        assert(lineGap >= 0),
        assert(indicators == null || children.length == indicators.length),
        super(key: key);

  final List<Widget?> children;
  final double itemGap;
  final double gutterSpacing;
  final List<Widget?> indicators;
  final bool isLeftAligned;
  final EdgeInsets padding;
  final ScrollController? controller;
  final int itemCount;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final bool primary;
  final bool reverse;

  final Color lineColor;
  final double lineGap;
  final double indicatorSize;
  final Color indicatorColor;
  final PaintingStyle indicatorStyle;
  final StrokeCap strokeCap;
  final double strokeWidth;
  final PaintingStyle style;
  final List<int> hideIndicator;

  @override
  Widget build(BuildContext context) {
    List<Widget> tileLineItems = [];
    for (int index = 0; index < itemCount; index++) {
      final child = children[index];
      // ignore: no_leading_underscores_for_local_identifiers
      final _indicators = indicators;

      Widget? indicator;
      if (_indicators != null) {
        indicator = _indicators[index];
      }

      final isFirst = index == 0;
      final isLast = index == itemCount - 1;

      print('${hideIndicator.toString()} = ${index}');
      bool unhide = true;
      if (hideIndicator != null) {
        unhide = hideIndicator.contains(index);
      } else {
        unhide = true;
      }
      final timelineTile = <Widget>[
        CustomPaint(
          foregroundPainter: _TimelinePainter(
            hideDefaultIndicator: true,
            lineColor: Theme.of(context).colorScheme.surfaceDim,
            indicatorColor: indicatorColor,
            indicatorSize: indicatorSize,
            indicatorStyle: indicatorStyle,
            isFirst: isFirst,
            isLast: isLast,
            lineGap: lineGap,
            strokeCap: strokeCap,
            strokeWidth: strokeWidth,
            style: style,
            itemGap: itemGap,
          ),
          child: SizedBox(
            height: double.infinity,
            width: indicatorSize,
            child: !unhide
                ? indicator
                : CustomPaint(
                    foregroundPainter: _TimelinePainter(
                      hideDefaultIndicator: true,
                      lineColor: Theme.of(context).colorScheme.surfaceDim,
                      indicatorColor: indicatorColor,
                      indicatorSize: indicatorSize,
                      indicatorStyle: indicatorStyle,
                      isFirst: isFirst,
                      isLast: isLast,
                      lineGap: lineGap,
                      strokeCap: strokeCap,
                      strokeWidth: strokeWidth,
                      style: style,
                      itemGap: itemGap,
                    ),
                    child: SizedBox(
                      child: !unhide
                          ? indicator
                          : Transform.rotate(
                              angle: 90 * math.pi / 180,
                              child: Divider(
                                thickness: strokeWidth,
                                color: Theme.of(context).colorScheme.surfaceDim,
                              ),
                            ),
                    ),
                  ),
          ),
        ),
        SizedBox(width: gutterSpacing),
        Expanded(child: child ?? Container()),
      ];

      tileLineItems.add(Padding(
        padding: EdgeInsets.symmetric(vertical: child is SizedBox ? 2 : 0),
        child: IntrinsicHeight(
          child: child is SizedBox
              ? indicator
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: isLeftAligned
                      ? timelineTile
                      : timelineTile.reversed.toList(),
                ),
        ),
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tileLineItems,
    );
    // return ListView.separated(
    //   padding: padding,
    //   separatorBuilder: (_, __) => SizedBox(height: itemGap),
    //   physics: physics,
    //   shrinkWrap: shrinkWrap,
    //   itemCount: itemCount,
    //   controller: controller,
    //   reverse: reverse,
    //   primary: primary,
    //   itemBuilder: (context, index) {},
    // );
  }
}

class _TimelinePainter extends CustomPainter {
  _TimelinePainter({
    required this.hideDefaultIndicator,
    required this.indicatorColor,
    required this.indicatorStyle,
    required this.indicatorSize,
    required this.lineGap,
    required this.strokeCap,
    required this.strokeWidth,
    required this.style,
    required this.lineColor,
    required this.isFirst,
    required this.isLast,
    required this.itemGap,
  })  : linePaint = Paint()
          ..color = lineColor
          ..strokeCap = strokeCap
          ..strokeWidth = strokeWidth
          ..style = style,
        circlePaint = Paint()
          ..color = indicatorColor
          ..style = indicatorStyle;

  final bool hideDefaultIndicator;
  final Color indicatorColor;
  final PaintingStyle indicatorStyle;
  final double indicatorSize;
  final double lineGap;
  final StrokeCap strokeCap;
  final double strokeWidth;
  final PaintingStyle style;
  final Color lineColor;
  final Paint linePaint;
  final Paint circlePaint;
  final bool isFirst;
  final bool isLast;
  final double itemGap;

  @override
  void paint(Canvas canvas, Size size) {
    final indicatorRadius = indicatorSize / 2;
    final halfItemGap = itemGap / 2;
    final indicatorMargin = indicatorRadius + lineGap;

    final top = size.topLeft(Offset(indicatorRadius, 0.0 - halfItemGap));
    final centerTop = size.centerLeft(
      Offset(indicatorRadius, -indicatorMargin),
    );

    final bottom = size.bottomLeft(Offset(indicatorRadius, 0.0 + halfItemGap));
    final centerBottom = size.centerLeft(
      Offset(indicatorRadius, indicatorMargin),
    );

    if (!isFirst) canvas.drawLine(top, centerTop, linePaint);
    if (!isLast) canvas.drawLine(centerBottom, bottom, linePaint);

    // if (!hideDefaultIndicator) {
    //   final Offset offsetCenter = size.centerLeft(Offset(indicatorRadius, 0));

    //   canvas.drawCircle(offsetCenter, indicatorRadius, circlePaint);
    // }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
