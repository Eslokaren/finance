import 'dart:math';
import 'dart:ui';

Color getRandomColor() {
    final _colors = [
      Color(0xffff6e40),
      Color(0xffff5252),
      Color(0xff7c4dff),
      Color(0xff18ffff),
      Color(0xffb2ff59),
      Color(0xffffd740),
      Color(0xff40c4ff),
    ];
    final rng = Random();
    return _colors[rng.nextInt(7)];
  }