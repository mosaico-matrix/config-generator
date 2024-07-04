import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class LedMatrix extends StatefulWidget {
  final int n;
  final int ledHeight;
  final double ledSpacing;
  final int repeatAnimationEvery;
  final Function(List<List<Color>>, Color)? onCreate;
  final Function(List<List<Color>>, Color)? onAnimate;
  final Color defaultLedColor = Colors.deepPurple;

   LedMatrix({
    Key? key,
    this.onAnimate,
    this.onCreate,
    this.n = 10,
    this.ledHeight = 4,
    this.ledSpacing = 1,
    this.repeatAnimationEvery = 500,
  }) : super(key: key);

  @override
  _LedMatrixState createState() => _LedMatrixState();
}

class _LedMatrixState extends State<LedMatrix> {
  late List<List<Color>> ledMatrix;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeLeds();
    _startAnimation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initializeLeds() {
    ledMatrix = List.generate(
      widget.n,
          (_) => List.generate(widget.n, (_) => Colors.black),
    );

    if (widget.onCreate != null) {
      widget.onCreate!(ledMatrix, widget.defaultLedColor);
    }
  }

  void _startAnimation() {
    if (widget.repeatAnimationEvery == 0) return;
    var duration = Duration(milliseconds: widget.repeatAnimationEvery);
    _timer = Timer.periodic(duration, (_) {
      if (widget.onAnimate != null) {
        setState(() {
          widget.onAnimate!(ledMatrix, widget.defaultLedColor);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    double containerWidth = widget.n * (widget.ledHeight + 2 * widget.ledSpacing);
    double containerHeight = widget.n * (widget.ledHeight + 2 * widget.ledSpacing);

    return Container(
      width: containerWidth,
      height: containerHeight,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.n,
              (rowIndex) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.n,
                  (colIndex) => _buildLed(rowIndex, colIndex),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLed(int rowIndex, int colIndex) {
    return Container(
      width: widget.ledHeight.toDouble(),
      height: widget.ledHeight.toDouble(),
      margin: EdgeInsets.all(widget.ledSpacing),
      decoration: BoxDecoration(
        color: ledMatrix[rowIndex][colIndex],
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
