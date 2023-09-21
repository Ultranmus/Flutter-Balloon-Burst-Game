import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final colorProvider = Provider<ColorState>((ref) {
  Random random = Random();
  bool randomColor = random.nextBool();
  ColorState colorState = ColorState(color: randomColor);
  return colorState;
});

class ColorState {
  bool color;

  ColorState({required this.color});

  bool selectedColor() {
    return color;
  }

  void updateColor(bool newColor) {
    color = newColor;
  }
}

final scoreProvider = StateProvider((ref) => 0);
