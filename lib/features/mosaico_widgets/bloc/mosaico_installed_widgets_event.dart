import 'package:equatable/equatable.dart';

abstract class MosaicoInstalledWidgetsEvent extends Equatable {}

class LoadInstalledWidgetsEvent extends MosaicoInstalledWidgetsEvent {
  @override
  List<Object> get props => [];
}