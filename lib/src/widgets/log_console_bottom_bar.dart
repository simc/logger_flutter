import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:logger_flutter_plus/src/theme/log_console_theme.dart';

class LogConsoleBottomBar extends StatelessWidget {
  const LogConsoleBottomBar({
    super.key,
    this.filterLevel,
    this.onChangedFilterLevel,
    this.onChangedFilterText,
    required this.theme,
  });

  final ValueChanged<Level?>? onChangedFilterLevel;
  final ValueChanged<String>? onChangedFilterText;
  final Level? filterLevel;
  final LogConsoleTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: theme.bottomAppBarColor,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(fontSize: 20),
              onChanged: onChangedFilterText,
              decoration: InputDecoration(
                labelText: "Filter log output",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: 20),
          DropdownButton<Level>(
            value: filterLevel,
            items: [
              DropdownMenuItem(
                child: Text("ALL"),
                value: null,
              ),
              DropdownMenuItem(
                child: Text("VERBOSE"),
                value: Level.verbose,
              ),
              DropdownMenuItem(
                child: Text("DEBUG"),
                value: Level.debug,
              ),
              DropdownMenuItem(
                child: Text("INFO"),
                value: Level.info,
              ),
              DropdownMenuItem(
                child: Text("WARNING"),
                value: Level.warning,
              ),
              DropdownMenuItem(
                child: Text("ERROR"),
                value: Level.error,
              ),
              DropdownMenuItem(
                child: Text("WTF"),
                value: Level.wtf,
              )
            ],
            onChanged: onChangedFilterLevel,
          )
        ],
      ),
    );
  }
}
