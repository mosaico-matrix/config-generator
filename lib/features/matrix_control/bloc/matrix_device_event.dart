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
  final MatrixDeviceConnectedState newState;

  UpdateMatrixDeviceStateEvent(this.newState);

  @override
  List<Object> get props => [newState];
}

class PingMatrixAndRefreshActiveWidgetEvent extends MatrixDeviceEvent
{
  final MatrixDeviceConnectedState previousState;
  
  PingMatrixAndRefreshActiveWidgetEvent(this.previousState);

  @override
  List<Object> get props => [previousState];
}
