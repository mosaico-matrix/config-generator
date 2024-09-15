import 'package:equatable/equatable.dart';

abstract class MosaicoStoreEvent extends Equatable {}

class LoadMosaicoStoreEvent extends MosaicoStoreEvent {
  @override
  List<Object> get props => [];
}

class InstallMosaicoWidgetEvent extends MosaicoStoreEvent {
  final String widgetId;

  InstallMosaicoWidgetEvent({required this.widgetId});

  @override
  List<Object> get props => [widgetId];
}