import 'package:flutter/material.dart';

import '../../../../common/widgets/led_matrix.dart';

class MosaicoLoadingIndicatorSmall extends StatelessWidget {

  MosaicoLoadingIndicatorSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return LedMatrix(
      n: 4,
      ledHeight: 5,
      ledSpacing: 1,
      repeatAnimationEvery: 100,
    );
  }
}
