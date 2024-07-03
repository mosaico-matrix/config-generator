import 'package:flutter/material.dart';

import '../../../../common/widgets/led_matrix.dart';

class MosaicoLoadingIndicator extends StatelessWidget {

  MosaicoLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return LedMatrix(
      n: 4,
      ledHeight: 20,
      ledSpacing: 2,
      repeatAnimationEvery: 100,
    );
  }
}
