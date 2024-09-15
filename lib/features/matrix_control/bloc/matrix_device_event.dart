import 'package:equatable/equatable.dart';

import 'matrix_device_state.dart';

abstract class MatrixDeviceEvent extends Equatable {}

class ConnectToMatrixEvent extends MatrixDeviceEvent {
  final String? address;

  ConnectToMatrixEvent({this.address});

  @override
  List<Object> get props => [];
}

class UpdateMatrixDeviceStateEvent extends MatrixDeviceEvent
{
  final MatrixDeviceConnectedState state;

  UpdateMatrixDeviceStateEvent(this.state);

  @override
  List<Object> get props => [state];
}
