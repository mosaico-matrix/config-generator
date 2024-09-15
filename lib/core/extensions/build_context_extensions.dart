import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mosaico_flutter_core/features/mosaico_loading/presentation/states/mosaico_loading_state.dart';

extension ContextLoading on BuildContext {
  void showLoading()
  {
    read<MosaicoLoadingState>().showOverlayLoading();
  }

  void hideLoading()
  {
    read<MosaicoLoadingState>().hideOverlayLoading();
  }
}