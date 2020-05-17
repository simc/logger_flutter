part of logger_flutter;

enum Gesture {
  shake,
  boxCircle,
}

class LogConsoleOnGesture extends StatefulWidget {
  final Widget child;
  final Gesture gesture;
  final bool dark;
  final bool debugOnly;
  final List<Level> levelsToFilter;
  final Level defaultLevel;
  final double lineWidth;

  LogConsoleOnGesture({
    @required this.child,
    this.gesture = Gesture.shake,
    this.dark,
    this.debugOnly = true,
    this.levelsToFilter,
    this.defaultLevel,
    this.lineWidth,
  });

  @override
  _LogConsoleOnGestureState createState() => _LogConsoleOnGestureState();
}

class _LogConsoleOnGestureState extends State<LogConsoleOnGesture> {
  bool _open = false;
  bool _shouldRender = true;

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
    if (_shouldRender) {
      return widget.gesture == Gesture.shake
          ? _OnShake(
              child: widget.child,
              onShowConsole: _openLogConsole,
            )
          : _OnBoxCircle(
              child: widget.child,
              onShowConsole: _openLogConsole,
            );
    }

    return widget.child;
  }

  void _init() => LogConsole.init();

  Future<void> _openLogConsole() async {
    if (_open) return;

    _open = true;

    final logConsole = LogConsole(
      showCloseButton: true,
      dark: widget.dark ?? Theme.of(context).brightness == Brightness.dark,
      levelsToFilter: widget.levelsToFilter,
      defaultLevel: widget.defaultLevel,
      lineWidth: widget.lineWidth,
    );
    PageRoute route;
    if (Platform.isIOS) {
      route = CupertinoPageRoute(builder: (_) => logConsole);
    } else {
      route = MaterialPageRoute(builder: (_) => logConsole);
    }

    await Navigator.push(context, route);
    _open = false;
  }
}

class _OnShake extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onShowConsole;

  const _OnShake({@required this.child, @required this.onShowConsole, Key key}) : super(key: key);

  @override
  __OnShakeState createState() => __OnShakeState();
}

class __OnShakeState extends State<_OnShake> {
  ShakeDetector _detector;

  @override
  void initState() {
    super.initState();

    _detector = ShakeDetector(
      onPhoneShake: () async => await widget.onShowConsole(),
    );
    _detector.startListening();
  }

  @override
  void dispose() {
    _detector.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

enum _Direction {
  left,
  right,
  up,
  down,
}

class _OnBoxCircle extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onShowConsole;

  const _OnBoxCircle({@required this.child, @required this.onShowConsole, Key key}) : super(key: key);

  @override
  __OnBoxCircleState createState() => __OnBoxCircleState();
}

class __OnBoxCircleState extends State<_OnBoxCircle> {
  static const _patternDirection = {_Direction.down, _Direction.right, _Direction.up, _Direction.left};

  List<DragUpdateDetails> _dragUpdateDetails = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (dragUpdateDetails) => _dragUpdateDetails.add(dragUpdateDetails),
      onPanEnd: (_) => _checkForPattern(),
      child: SizedBox.expand(
        child: Container(
          color: Colors.transparent,
          child: widget.child,
        ),
      ),
    );
  }

  void _checkForPattern() {
    const tol = 10;
    if (_dragUpdateDetails.length > 0) {
      Offset start = _dragUpdateDetails.first.globalPosition;
      List<_Direction> directions = [];
      for (final details in _dragUpdateDetails) {
        final dx = (details.globalPosition - start).dx;
        final dy = (details.globalPosition - start).dy;

        // if one axis delta is sufficiently large, determine direction and set new start reference point
        if (dx.abs() > tol || dy.abs() > tol) {
          _Direction direction;
          if (dy.abs() > dx.abs()) {
            direction = dy < 0 ? _Direction.up : _Direction.down;
          } else {
            direction = dx > 0 ? _Direction.right : _Direction.left;
          }
          directions.add(direction);
          start = details.globalPosition;
        }
      }

      if (directions.length > 0) {
        /// determine if directions match pattern
        final filteredDirections = Set.from(directions);
        if (setEquals(filteredDirections, _patternDirection)) {
          widget.onShowConsole();
        }
      }

      // reset for next test
      _dragUpdateDetails.clear();
    }
  }
}
