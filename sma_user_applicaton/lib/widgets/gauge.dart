import 'package:flutter/material.dart';
import 'dart:math' as math;

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(size.width, size.height), 70, Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ArcPainter extends CustomPainter {
  final double radius;
  final double startAngle;
  final double endAngle;
  double angle;

  ArcPainter(
      {required this.radius,
      required this.angle,
      this.startAngle = 0,
      this.endAngle = math.pi});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..strokeWidth = 15
      ..style = PaintingStyle.stroke
      ..shader = SweepGradient(
              colors: const [
                Colors.red,
                Colors.orange,
                Colors.green,
              ],
              startAngle: startAngle,
              endAngle: endAngle,
              tileMode: TileMode.clamp,
              stops: const [0, 0.5, 1.0])
          .createShader(
              Rect.fromCircle(center: const Offset(20, 40), radius: radius));

    canvas.drawArc(Rect.fromCircle(center: const Offset(0, 30), radius: radius),
        startAngle, angle, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class Gauge extends StatelessWidget {
  int minValue;
  int maxValue;
  String text;
  double value;
  double radius;
  final double minAngle = math.pi;
  final double maxAngle = 2 * math.pi;

  Gauge(
      {this.minValue = 0,
      this.maxValue = 1000,
      this.text = "",
      required this.value,
      required this.radius});

  double _computeAngle() {
    double angle = ((maxAngle - minAngle) / (maxValue - minValue)) * value;

    if (angle < 0) {
      angle = 0;
    }

    if (angle > (maxAngle - minAngle)) {
      angle = (maxAngle - minAngle);
    }

    return angle;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
            bottom: 0,
            width: 50,
            child: Container(
                alignment: Alignment.center,
                width: 100,
                height: 50,
                child: Text(
                  text,
                ))),
        SizedBox(
            height: 70,
            width: 100,
            child: Container(
              alignment: Alignment.center,
              child: CustomPaint(
                  painter: ArcPainter(
                      radius: radius,
                      angle: _computeAngle(),
                      startAngle: minAngle,
                      endAngle: maxAngle)),
            ))
      ],
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: Center(
              child: Gauge(
            value: 100,
            radius: 70,
          )),
        ));
  }
}

void main() {
  runApp(MyApp());
}
