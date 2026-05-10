import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

extension AnimationExtensions on Widget {
  Widget fadeSlide({int delay = 0, Offset begin = const Offset(0, 0.2)}) {
    return animate()
        .fade(delay: delay.ms, duration: 300.ms)
        .slide(begin: begin, delay: delay.ms, duration: 300.ms);
  }
}
