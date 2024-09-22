import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mosaico_flutter_core/core/utils/toaster.dart';
import 'package:mosaico_flutter_core/features/matrix_control/bloc/matrix_device_bloc.dart';
import 'package:mosaico_flutter_core/features/matrix_control/bloc/matrix_device_state.dart';
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


extension EnsureMatrixConnected on BuildContext {
  void ensureMatrixConnected()
  {
    if(read<MatrixDeviceBloc>().state is! MatrixDeviceConnectedState) {
      Toaster.warning('You are not connected to a matrix device');
      throw Exception('You need to be connected to a matrix device to perform this action');
    }

  }
}