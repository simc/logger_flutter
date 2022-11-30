import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

class LogRenderedEvent {
  const LogRenderedEvent({
    required this.id,
    required this.level,
    required this.span,
    required this.lowerCaseText,
  });

  final int id;
  final Level level;
  final TextSpan span;
  final String lowerCaseText;
}
