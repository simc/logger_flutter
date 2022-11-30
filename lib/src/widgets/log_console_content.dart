import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:logger_flutter_plus/src/utils/log_console_manager.dart';

class LogConsoleContent extends StatefulWidget {
  const LogConsoleContent({
    super.key,
    required this.logFontSize,
    required this.filterLevel,
    required this.filterText,
    required this.scrollController,
    required this.logConsoleManager,
  });

  final double logFontSize;
  final Level? filterLevel;
  final String filterText;

  final ScrollController scrollController;
  final LogConsoleManager logConsoleManager;

  @override
  State<LogConsoleContent> createState() => _LogConsoleContentState();
}

class _LogConsoleContentState extends State<LogConsoleContent> {
  @override
  void initState() {
    super.initState();
    widget.logConsoleManager.addListener(_updateList);
  }

  @override
  void dispose() {
    widget.logConsoleManager.removeListener(_updateList);
    super.dispose();
  }

  void _updateList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 1600,
        child: ListView.builder(
          key: PageStorageKey('LogConsoleContent'),
          controller: widget.scrollController,
          itemBuilder: (context, index) => Text.rich(
            widget.logConsoleManager.logs[index].span,
            key: ValueKey(widget.logConsoleManager.logs[index].id),
            style: theme.textTheme.bodyText1?.copyWith(fontSize: widget.logFontSize),
          ),
          itemCount: widget.logConsoleManager.logs.length,
        ),
      ),
    );
  }
}
