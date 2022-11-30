import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:logger_flutter_plus/src/utils/log_console_manager.dart';
import 'package:logger_flutter_plus/src/widgets/log_console_app_bar.dart';
import 'package:logger_flutter_plus/src/widgets/log_console_bottom_bar.dart';
import 'package:logger_flutter_plus/src/widgets/log_console_content.dart';

class LogConsoleWidget extends StatefulWidget {
  const LogConsoleWidget({
    super.key,
    required this.logConsoleManager,
    this.showCloseButton = false,
  });

  final bool showCloseButton;
  final LogConsoleManager logConsoleManager;

  @override
  State<LogConsoleWidget> createState() => _LogConsoleWidgetState();
}

class _LogConsoleWidgetState extends State<LogConsoleWidget> {
  // Controllers
  late final _scrollController = ScrollController();

  // State
  var _followBottom = true;
  var _logFontSize = 14.0;
  Level? _filterLevel;
  var _filterText = '';

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_checkScrollPosition);
    widget.logConsoleManager.addListener(_updateLogManagerCallback);
  }

  Future<void> _checkScrollPosition({Duration delay = Duration.zero}) async {
    await Future.delayed(delay);

    final scrolledToBottom = _scrollController.offset >= _scrollController.position.maxScrollExtent;

    if (_followBottom != scrolledToBottom) {
      setState(() {
        _followBottom = scrolledToBottom;
      });
    }
  }

  void _updateLogManagerCallback() => _checkScrollPosition(delay: const Duration(milliseconds: 400));

  @override
  void dispose() {
    _scrollController.dispose();
    widget.logConsoleManager.removeListener(_updateLogManagerCallback);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            LogConsoleAppBar(
              showCloseButton: widget.showCloseButton,
              onDecreaseFontSize: () {
                setState(() {
                  _logFontSize--;
                });
              },
              onIncreaseFontSize: () {
                setState(() {
                  _logFontSize++;
                });
              },
            ),
            Expanded(
              child: LogConsoleContent(
                logFontSize: _logFontSize,
                filterLevel: _filterLevel,
                filterText: _filterText,
                scrollController: _scrollController,
                logConsoleManager: widget.logConsoleManager,
              ),
            ),
            LogConsoleBottomBar(
              filterLevel: _filterLevel,
              onChangedFilterLevel: (filterLevel) {
                widget.logConsoleManager.setFilterLevel(filterLevel);
                setState(() {
                  _filterLevel = filterLevel;
                });
              },
              onChangedFilterText: (filterText) {
                widget.logConsoleManager.setFilterText(filterText);
                setState(() {
                  _filterText = filterText;
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: _followBottom ? 0 : 1,
        duration: Duration(milliseconds: 150),
        child: Padding(
          padding: EdgeInsets.only(bottom: 60),
          child: FloatingActionButton(
            mini: true,
            clipBehavior: Clip.antiAlias,
            child: Icon(Icons.arrow_downward),
            onPressed: _scrollToBottom,
          ),
        ),
      ),
    );
  }

  Future<void> _scrollToBottom() async {
    var scrollPosition = _scrollController.position;
    await _scrollController.animateTo(
      scrollPosition.maxScrollExtent,
      duration: new Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );

    setState(() {
      _followBottom = true;
    });
  }
}
