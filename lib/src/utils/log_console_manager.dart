import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:logger_flutter_plus/logger_flutter_plus.dart';
import 'package:logger_flutter_plus/src/models/log_rendered_event.dart';
import 'package:logger_flutter_plus/src/utils/ansi_parser.dart';

class LogConsoleManager extends ChangeNotifier {
  final ListQueue<LogRenderedEvent> _buffer = ListQueue();
  final AnsiParser _ansiParser = AnsiParser(false);

  List<LogRenderedEvent> get logs => _buffer.toList();

  void addLog(OutputEvent event) {
    final text = event.lines.join('\n');
    _ansiParser.parse(text);

    final logEvent = LogRenderedEvent(
      id: (_buffer.lastOrNull?.id ?? 0) + 1,
      level: event.level,
      span: TextSpan(children: _ansiParser.spans),
      lowerCaseText: text.toLowerCase(),
    );

    _buffer.add(logEvent);
    notifyListeners();
  }
}
