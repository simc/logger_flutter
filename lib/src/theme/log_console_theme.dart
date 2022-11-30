import 'package:flutter/material.dart';
import 'package:logger_flutter_plus/src/theme/log_color_schema.dart';

class LogConsoleTheme {
  const LogConsoleTheme._({
    required this.bottomAppBarColor,
    required this.scaffoldBackgroundColor,
    required this.bodyLarge,
  });

  factory LogConsoleTheme.byTheme(
    ThemeData theme,
  ) =>
      LogConsoleTheme._(
        bottomAppBarColor: theme.bottomAppBarTheme.color ?? theme.bottomAppBarColor,
        scaffoldBackgroundColor: theme.scaffoldBackgroundColor,
        bodyLarge: theme.textTheme.bodyLarge,
      );

  factory LogConsoleTheme.dark() => LogConsoleTheme._(
        bottomAppBarColor: LogColorSchema.bottomAppBarColor,
        scaffoldBackgroundColor: LogColorSchema.scaffoldBackgroundColor,
        bodyLarge: TextStyle(
          color: LogColorSchema.logTextColor,
        ),
      );

  final Color bottomAppBarColor;
  final Color scaffoldBackgroundColor;

  final TextStyle? bodyLarge;
}
