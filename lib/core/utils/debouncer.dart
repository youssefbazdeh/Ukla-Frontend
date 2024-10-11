import 'dart:async';

import 'package:flutter/scheduler.dart';

/// HOW TO USE :
///
/// final _debouncer = Debouncer(milliseconds: 500);
///
/// onTextChange(String text) {
///
///    _debouncer.run(() =>//Utils.printf(text));
///
/// }

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;
  Debouncer({required this.milliseconds});
  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
