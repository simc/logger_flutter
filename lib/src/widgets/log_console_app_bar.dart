import 'package:flutter/material.dart';
import 'package:logger_flutter_plus/src/theme/log_console_theme.dart';

class LogConsoleAppBar extends StatelessWidget {
  const LogConsoleAppBar({
    super.key,
    this.showCloseButton = true,
    required this.onIncreaseFontSize,
    required this.onDecreaseFontSize,
    required this.theme,
  });

  final bool showCloseButton;

  final VoidCallback onDecreaseFontSize;
  final VoidCallback onIncreaseFontSize;
  final LogConsoleTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: theme.bottomAppBarColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            "Log Console",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: onIncreaseFontSize,
          ),
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: onDecreaseFontSize,
          ),
          if (showCloseButton)
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
        ],
      ),
    );
  }
}
