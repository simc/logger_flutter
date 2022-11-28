import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeDetector {
  ShakeDetector({
    required this.onPhoneShake,
    this.shakeThresholdGravity = 1.25,
    this.minTimeBetweenShakes = 160,
    this.shakeCountResetTime = 1500,
    this.minShakeCount = 2,
  });

  final VoidCallback onPhoneShake;

  final double shakeThresholdGravity;
  final int minTimeBetweenShakes;
  final int shakeCountResetTime;
  final int minShakeCount;

  int _shakeCount = 0;
  int _lastShakeTimestamp = DateTime.now().millisecondsSinceEpoch;
  StreamSubscription? _streamSubscription;

  /// Starts listening to accerelometer events
  void startListening() {
    _streamSubscription = accelerometerEvents
        .map((event) {
          final gX = event.x / 9.81;
          final gY = event.y / 9.81;
          final gZ = event.z / 9.81;

          // gForce will be close to 1 when there is no movement.
          final gForce = sqrt(gX * gX + gY * gY + gZ * gZ);

          return gForce;
        })
        .where((gForce) => gForce > shakeThresholdGravity)
        .where((_) {
          var now = DateTime.now().millisecondsSinceEpoch;
          // ignore shake events too close to each other
          return _lastShakeTimestamp + minTimeBetweenShakes < now;
        })
        .map((_) => _lastShakeTimestamp)
        .map((lastShakeTimestamp) {
          var now = DateTime.now().millisecondsSinceEpoch;

          _shakeCount = lastShakeTimestamp + shakeCountResetTime < now ? 0 : _shakeCount + 1;
          _lastShakeTimestamp = now;

          return _shakeCount;
        })
        .where((shakeCount) => shakeCount >= minShakeCount)
        .listen((event) => onPhoneShake());
  }

  /// Stops listening to accelerometer events
  void stopListening() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }
}
