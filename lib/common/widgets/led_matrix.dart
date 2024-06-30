import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class LedMatrix extends StatefulWidget {

  final int n;
  final int ledHeight;
  final double ledSpacing;
  final int repeatAnimationEvery;

  const LedMatrix({super.key, this.n = 14, this.ledHeight = 3, this.ledSpacing = 1, this.repeatAnimationEvery = 500});

  @override
  _LedMatrixState createState() => _LedMatrixState();
}

class _LedMatrixState extends State<LedMatrix> {
  late List<bool> leds;
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
    // Initialize the LEDs randomly
    leds = List.generate(widget.n * widget.n, (_) => Random().nextBool());
  }

  void _startAnimation() {
    var duration = Duration(milliseconds: widget.repeatAnimationEvery); // Change interval here
    _timer = Timer.periodic(duration, (_) {
      setState(() {
        _toggleRandomLed();
        _toggleRandomLed(); // Call it twice to turn on and off some other LEDs
      });
    });
  }

  void _toggleRandomLed() {
    final random = Random();
    int index = random.nextInt(leds.length);
    leds[index] = !leds[index];
  }

  @override
  Widget build(BuildContext context) {
    int rowCount = sqrt(leds.length).toInt();
    double containerWidth = rowCount * (widget.ledHeight + 2*widget.ledSpacing);
    double containerHeight = rowCount * (widget.ledHeight + 2*widget.ledSpacing);

    return Container(
      width: containerWidth,
      height: containerHeight,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      // Create nxn matrix of leds
      child: Wrap(
        children: [
          Column(
            children: List.generate(
              // Create rows
              sqrt(leds.length).toInt(),
                  (index) => Row(
                // Create columns
                children: List.generate(
                  sqrt(leds.length).toInt(),
                      (subIndex) {
                    int ledIndex = index * sqrt(leds.length).toInt() + subIndex;
                    return _buildLed(ledIndex);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _generateRandomColor() {
    // Create list of colors
    List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.teal,
    ];
    // Return random color
    return colors[Random().nextInt(colors.length)];
  }

  Widget _buildLed(int index) {
    return Container(
      width: widget.ledHeight.toDouble(),
      height: widget.ledHeight.toDouble(),
      margin: EdgeInsets.all(widget.ledSpacing),
      decoration: BoxDecoration(
        color: leds[index] ? _generateRandomColor() : Colors.black,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
