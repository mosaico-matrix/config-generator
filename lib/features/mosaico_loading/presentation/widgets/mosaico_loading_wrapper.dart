import 'package:flutter/material.dart';
import 'package:mosaico_flutter_core/common/widgets/matrices/loading_matrix.dart';
import 'package:provider/provider.dart';
import '../../../../common/widgets/matrices/led_matrix.dart';
import '../states/mosaico_loading_state.dart';

class MosaicoLoadingWrapper extends StatelessWidget {
  final Widget child;
  MosaicoLoadingWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MosaicoLoadingState>(
      create: (context) => MosaicoLoadingState(),
      child: Consumer<MosaicoLoadingState>(
        builder: (context, state, _) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Stack(
              children: [
                child,
                if (state.isOverlayLoading)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(child: LoadingMatrix()),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

}