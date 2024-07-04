import 'dart:math';

import 'package:flutter/material.dart';

import 'led_matrix.dart';

class LoadingMatrix extends StatelessWidget {

  final int n;
  LoadingMatrix({super.key, this.n = 10});

  @override
  Widget build(BuildContext context) {
    return LedMatrix(
      n: n,
      onCreate: (ledMatrix, defaultLedColor) {
        for (int i = 0; i < ledMatrix.length; i++) {
          for (int j = 0; j < ledMatrix[i].length; j++) {
            ledMatrix[i][j] = _generateRandomColor();
          }
        }
      },
      onAnimate: (ledMatrix, defaultLedColor) {
        for (int i = 0; i < ledMatrix.length; i++) {
          for (int j = 0; j < ledMatrix[i].length; j++) {
            ledMatrix[i][j] = _generateRandomColor();
          }
        }
      },
    );
  }

  Color _generateRandomColor() {
    List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.teal,

      // More black!!
      Colors.black,
      Colors.black,
      Colors.black,
      Colors.black,
      Colors.black,
    ];
    return colors[Random().nextInt(colors.length)];
  }
}
