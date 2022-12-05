import 'dart:async';
import 'package:flutter/material.dart';

/// A debouncer that can be used to delay execution of a function. 
/// Used in search function to delay the search until the user has stopped typing.
class Debouncer {
  Debouncer({
    required this.milliseconds,
  });

  final int milliseconds;
  Timer? _timer;

  void run(VoidCallback action) {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
