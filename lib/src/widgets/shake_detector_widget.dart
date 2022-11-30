import 'package:flutter/material.dart';
import 'package:logger_flutter_plus/src/shake/shake_detector.dart';

class ShakeDetectorWidget extends StatefulWidget {
  const ShakeDetectorWidget({
    super.key,
    required this.child,
    required this.shakeDetector,
  });

  final Widget child;
  final ShakeDetector shakeDetector;

  @override
  _ShakeDetectorWidgetState createState() => _ShakeDetectorWidgetState();
}

class _ShakeDetectorWidgetState extends State<ShakeDetectorWidget> {
  @override
  void initState() {
    super.initState();

    widget.shakeDetector.startListening();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    widget.shakeDetector.stopListening();
    super.dispose();
  }
}
