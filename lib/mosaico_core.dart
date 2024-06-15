import 'package:flutter/material.dart';

import 'configuration/app_color_scheme.dart';

class MosaicoCore extends StatelessWidget {

  final Widget child;
  const MosaicoCore({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
