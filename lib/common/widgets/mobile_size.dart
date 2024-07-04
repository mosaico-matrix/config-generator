import 'package:flutter/material.dart';


/// Wrap a widget with a [ConstrainedBox] that limits the width to a fixed value
/// This is used to preview the mobile version of a widget in a desktop environment
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
