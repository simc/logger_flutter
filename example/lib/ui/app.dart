import 'package:flutter/material.dart';
import 'package:logger_flutter_plus/logger_flutter_plus.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.logConsoleManager,
  });

  final LogConsoleManager logConsoleManager;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        body: ShakeDetectorWidget(
          shakeDetector: DefaultShakeDetector(
            onPhoneShake: () {},
          ),
          child: LogConsoleWidget(
            logConsoleManager: logConsoleManager,
          ),
        ),
      ),
    );
  }
}
