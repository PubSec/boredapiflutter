import 'package:flutter/material.dart';

Color getBackgroundColor(Set<MaterialState> state) {
  const interactiveState = <MaterialState>{
    MaterialState.pressed,
  };
  if (state.any(interactiveState.contains)) {
    return Colors.blue.shade500;
  } else {
    return Colors.blue.shade400;
  }
}
