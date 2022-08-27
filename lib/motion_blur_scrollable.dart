import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:scroll_experiments/umbragen/motion_blur.dart';

class ScrollableBlur extends StatefulWidget {
  const ScrollableBlur({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<ScrollableBlur> createState() => _ScrollableBlurState();
}

class _ScrollableBlurState extends State<ScrollableBlur> {
  final _boundaryKey = GlobalKey();

  ui.Image? image;
  int lastTS = DateTime.now().millisecondsSinceEpoch;
  double lastPixels = 0;

  double blurAmount = 0;
  double blueAngle = pi / 2;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  bool captureLock = false;

  Future<void> captureImage() async {
    if (captureLock) return;
    captureLock = true;
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final boundary = _boundaryKey.currentContext!.findRenderObject()!
        as RenderRepaintBoundary;
    final im = await boundary.toImage(pixelRatio: pixelRatio);
    setState(() {
      captureLock = false;
      image = im;
    });
  }

  bool onScrollNotification(ScrollMetricsNotification notification) {
    if (notification.depth != 0) {
      return false;
    }

    final ts = DateTime.now().millisecondsSinceEpoch;
    final deltaT = ts - lastTS;
    if (deltaT < 12) return false;
    final pixels = notification.metrics.pixels;

    if (notification.metrics.atEdge) {
      setState(() {
        blurAmount = 0.0;
      });
    } else {
      setState(() {
        final deltaPixels = (pixels - lastPixels).abs();
        final velo = deltaPixels / (deltaT * 0.0001);
        blurAmount = velo > 1.0 ? (deltaPixels / 800) : 0.0;
        blueAngle = notification.metrics.axis == Axis.horizontal ? pi : pi / 2;
      });
    }

    lastTS = ts;
    lastPixels = pixels;

    Timer(
      const Duration(milliseconds: 60),
      afterScrollCheck,
    );

    return false;
  }

  void afterScrollCheck() {
    if (blurAmount == 0.0) {
      return;
    }
    final ts = DateTime.now().millisecondsSinceEpoch;
    final deltaT = ts - lastTS;

    if (deltaT >= 60) {
      setState(() {
        blurAmount = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (blurAmount != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => captureImage());
    }

    final image = this.image;

    return Stack(
      fit: StackFit.passthrough,
      children: [
        NotificationListener<ScrollMetricsNotification>(
          onNotification: onScrollNotification,
          child: RepaintBoundary(
            key: _boundaryKey,
            child: widget.child,
          ),
        ),
        if (image != null && blurAmount > 0.0)
          IgnorePointer(
            child: MotionBlur(
              tInput: image,
              delta: blurAmount,
              angle: pi / 2,
            ),
          )
      ],
    );
  }
}
