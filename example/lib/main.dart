import 'package:flutter/material.dart';
import 'dart:async';

import 'package:logger/logger.dart';
import 'package:logger_flutter/logger_flutter.dart';

void main() {
  runApp(MyApp());
  log();
}

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

void log() {
  logger.d("Log message with 2 methods");

  loggerNoStack.i("Info message");

  loggerNoStack.w("Just a warning!");

  logger.e("Error! Something bad happened", error: "Test Error");

  loggerNoStack.t({"key": 5, "value": "something"});

  Future.delayed(Duration(seconds: 5), log);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LogConsoleOnShake(
          dark: true,
          child: Center(
            child: Text("Shake Phone to open Console."),
          ),
        ),
      ),
    );
  }
}
