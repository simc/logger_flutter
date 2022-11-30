import 'package:flutter/material.dart';

abstract class ShakeDetector {
  abstract final VoidCallback onPhoneShake;

  abstract final double shakeThresholdGravity;
  abstract final int minTimeBetweenShakes;
  abstract final int shakeCountResetTime;
  abstract final int minShakeCount;

  /// Starts listening to accerelometer events
  void startListening();

  /// Stops listening to accelerometer events
  void stopListening();
}
