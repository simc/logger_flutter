import 'dart:async';

import 'package:example/ui/app.dart';
import 'package:flutter/material.dart';
import 'package:logger_flutter_plus/logger_flutter_plus.dart';

void main() {
  var logConsoleManager = LogConsoleManager(
    isDark: true,
  );

  final appOutput = AppLogOutput(logConsoleManager: logConsoleManager);

  var logger = Logger(
    output: appOutput,
    printer: PrettyPrinter(),
  );

  var loggerNoStack = Logger(
    output: appOutput,
    printer: PrettyPrinter(methodCount: 0),
  );

  runApp(
    MyApp(
      logConsoleManager: logConsoleManager,
    ),
  );

  log(logger, loggerNoStack);
}

class AppLogOutput extends LogOutput {
  AppLogOutput({
    required this.logConsoleManager,
  });
  final LogConsoleManager logConsoleManager;

  @override
  void output(OutputEvent event) {
    logConsoleManager.addLog(event);
  }

  @override
  void destroy() {
    logConsoleManager.dispose();
    super.destroy();
  }
}

void log(Logger logger, Logger loggerNoStack) {
  logger.d("Log message with 2 methods");

  loggerNoStack.i("Info message");

  loggerNoStack.w("Just a warning!");

  logger.e("Error! Something bad happened", "Test Error");

  loggerNoStack.v({"key": 5, "value": "something"});

  Future.delayed(const Duration(seconds: 5), () => log(logger, loggerNoStack));
}
