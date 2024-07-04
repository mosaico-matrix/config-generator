import 'dart:math';

import 'package:flutter/material.dart';

import 'led_matrix.dart';

class NoDataMatrix extends StatelessWidget {

  final int n = 10;
  NoDataMatrix({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return LedMatrix(
      n: n,
      ledHeight: 12,
      onCreate: (ledMatrix,defaultLedColor) {
        _displaySadFace(ledMatrix,defaultLedColor);
      },
      onAnimate: (ledMatrix,defaultLedColor) {
        _blinkSadFace(ledMatrix,defaultLedColor);
      },
    );
  }

  void _displaySadFace(List<List<Color>> ledMatrix, Color color) {


    // Sad face pattern for 10x10 matrix
    // Eyes
    ledMatrix[2][2] = color;
    ledMatrix[2][7] = color;

    // Mouth
    ledMatrix[7][2] = color;
    ledMatrix[6][3] = color;
    ledMatrix[6][4] = color;
    ledMatrix[6][5] = color;
    ledMatrix[6][6] = color;
    ledMatrix[7][7] = color;

  }

  void _blinkSadFace(List<List<Color>> ledMatrix, Color color) {

    // Throw a coin to decide if we should switch eyes
    if (Random().nextBool() && Random().nextBool()) {
      ledMatrix[2][2] = Colors.black;
      ledMatrix[2][7] = Colors.black;
      ledMatrix[2][3] = color;
      ledMatrix[2][8] = color;
    } 
    else{
      ledMatrix[2][2] = color;
      ledMatrix[2][7] = color;
      ledMatrix[2][3] = Colors.black;
      ledMatrix[2][8] = Colors.black;
    }
  }
}
