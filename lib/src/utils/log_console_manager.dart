import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:logger_flutter_plus/logger_flutter_plus.dart';
import 'package:logger_flutter_plus/src/models/log_rendered_event.dart';
import 'package:logger_flutter_plus/src/utils/ansi_parser.dart';

class LogConsoleManager extends ChangeNotifier {
  LogConsoleManager({
    required bool isDark,
  }) : _ansiParser = AnsiParser(isDark);

  final ListQueue<LogRenderedEvent> _buffer = ListQueue();
  final AnsiParser _ansiParser;

  Level? _filterLevel;
  String _filterText = '';

  List<LogRenderedEvent> get logs => _buffer
      .where((element) => _filterLevel == null ? true : element.level == _filterLevel)
      .where((element) => _filterText.isEmpty ? true : element.lowerCaseText.contains(_filterText))
      .toList();

  void setFilterLevel(Level? level) {
    _filterLevel = level;
    notifyListeners();
  }

  void setFilterText(String filterText) {
    _filterText = filterText;
    notifyListeners();
  }

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
