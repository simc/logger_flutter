part of logger_flutter;

class LogConsoleOnShake extends StatefulWidget {
  final Widget child;
  final bool dark;
  final bool debugOnly;

  LogConsoleOnShake({
    @required this.child,
    this.dark,
    this.debugOnly = true,
  });

  @override
  _LogConsoleOnShakeState createState() => _LogConsoleOnShakeState();
}

class _LogConsoleOnShakeState extends State<LogConsoleOnShake> {
  ShakeDetector _detector;
  bool _open = false;

  @override
  void initState() {
    super.initState();

    if (widget.debugOnly) {
      assert(() {
        _init();
        return true;
      }());
    } else {
      _init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  _init() {
    _detector = ShakeDetector(onPhoneShake: _openLogConsole);
    _detector.startListening();
  }

  _openLogConsole() async {
    if (_open) return;

    _open = true;
    await LogConsole.open(context, dark: widget.dark);
    _open = false;
  }

  @override
  void dispose() {
    _detector.stopListening();
    super.dispose();
  }
}
