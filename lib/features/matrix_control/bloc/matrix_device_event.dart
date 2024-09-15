import 'package:equatable/equatable.dart';

abstract class MatrixDeviceEvent extends Equatable {}

class ConnectToMatrixEvent extends MatrixDeviceEvent {
  final String? address;

  ConnectToMatrixEvent({this.address});

  @override
  List<Object> get props => [];
}
