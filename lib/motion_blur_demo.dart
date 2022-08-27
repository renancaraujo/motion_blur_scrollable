import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:scroll_experiments/umbragen/motion_blur.dart';

class MotionBlurDemoWidget extends StatefulWidget {
  const MotionBlurDemoWidget({super.key});

  @override
  State<MotionBlurDemoWidget> createState() => _GlowWidgetState();
}

class _GlowWidgetState extends State<MotionBlurDemoWidget> {
  ui.Image? barcelos;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    getBarcelos();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getBarcelos() async {
    final imageData = await rootBundle.load('assets/image.jpg');
    final image = await decodeImageFromList(imageData.buffer.asUint8List());
    setState(() {
      barcelos = image;
    });
  }

  double delta = 0;


  void handleVerticalDragUpdate(DragUpdateDetails details, double height) {
    final exp =  (details.localPosition.dy / height);

    final exx = 10 ^ (1000 * exp).ceil();

    setState(() {
      delta= 1 / exx;
    });
  }

  @override
  Widget build(BuildContext context) {
    final barcelos = this.barcelos;

    if (barcelos == null) {
      return const SizedBox.shrink();
    }

    return Center(
      child: AspectRatio(
        aspectRatio: barcelos.width/ barcelos.height,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onVerticalDragUpdate: (details) => handleVerticalDragUpdate(details, constraints.maxHeight),
              child: MotionBlur(
                tInput: barcelos,
                delta: delta,
                angle: pi / 1,
              ),
            );
          }
        ),
      ),
    );
  }
}
