part of logger_flutter;

enum _Direction {
  left,
  right,
  up,
  down,
}

class LogConsoleOnBoxGesture extends StatefulWidget {
  final Widget child;
  final bool dark;
  final bool debugOnly;
  final List<Level> levelsToFilter;
  final Level defaultLevel;
  final double lineWidth;

  LogConsoleOnBoxGesture({
    @required this.child,
    this.dark,
    this.debugOnly = true,
    this.levelsToFilter,
    this.defaultLevel,
    this.lineWidth,
  });

  @override
  _LogConsoleOnCircleGestureState createState() => _LogConsoleOnCircleGestureState();
}

class _LogConsoleOnCircleGestureState extends State<LogConsoleOnBoxGesture> {
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

  List<DragUpdateDetails> _dragUpdateDetails = [];
  static const _patternDirection = {_Direction.down, _Direction.right, _Direction.up, _Direction.left};

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

    /// determine if directions match pattern
    final filteredDirections = Set.from(directions);
    if (setEquals(filteredDirections, _patternDirection)) {
      _openLogConsole();
    }

    // reset for next test
    _dragUpdateDetails.clear();
  }

  void _init() {
    LogConsole.init();
  }

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
