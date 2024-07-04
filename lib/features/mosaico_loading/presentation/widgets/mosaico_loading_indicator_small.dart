import 'package:flutter/material.dart';
import '../../../../common/widgets/matrices/loading_matrix.dart';

class MosaicoLoadingIndicatorSmall extends StatelessWidget {

  MosaicoLoadingIndicatorSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingMatrix(
      n: 5,
    );
  }
}
