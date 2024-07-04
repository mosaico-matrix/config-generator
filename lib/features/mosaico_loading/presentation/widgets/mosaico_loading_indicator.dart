import 'package:flutter/material.dart';
import 'package:mosaico_flutter_core/common/widgets/matrices/loading_matrix.dart';

import '../../../../common/widgets/matrices/led_matrix.dart';

class MosaicoLoadingIndicator extends StatelessWidget {

  MosaicoLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingMatrix();
  }
}
