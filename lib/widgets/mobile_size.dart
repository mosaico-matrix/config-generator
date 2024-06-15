import 'package:flutter/material.dart';

class MobileSize extends StatelessWidget {

  final Widget _child;
  const MobileSize({super.key, required Widget child}) : _child = child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 650),
        child: _child,
      ),
    );
  }
}
