import 'package:equatable/equatable.dart';
import 'package:mosaico_flutter_core/features/mosaico_widgets/data/models/mosaico_widget.dart';
import 'package:mosaico_flutter_core/features/mosaico_widgets/data/models/mosaico_widget_configuration.dart';

abstract class MatrixDeviceState extends Equatable {}

class MatrixDeviceInitialState extends MatrixDeviceState {
  @override
  List<Object> get props => [];
}

class MatrixDeviceConnectingState extends MatrixDeviceState {
  @override
  List<Object> get props => [];
}

/// We assume that connected means "COAP connected"
class MatrixDeviceConnectedState extends MatrixDeviceState {
  final String address;
  final MosaicoWidget? activeWidget;
  final MosaicoWidgetConfiguration? activeWidgetConfiguration;
  MatrixDeviceConnectedState({required this.address, this.activeWidget, this.activeWidgetConfiguration});

  @override
  List<Object> get props => [activeWidget ?? '', activeWidgetConfiguration ?? '', address];
}

class MatrixDeviceDisconnectedState extends MatrixDeviceState {

  final bool bleConnected;
  MatrixDeviceDisconnectedState({required this.bleConnected});

  @override
  List<Object> get props => [bleConnected];
}