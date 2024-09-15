import 'package:equatable/equatable.dart';
import 'package:mosaico_flutter_core/features/mosaico_widgets/data/models/mosaico_widget.dart';

abstract class MosaicoStoreState extends Equatable {}

class MosaicoStoreInitialState extends MosaicoStoreState {
  @override
  List<Object> get props => [];
}

class MosaicoStoreLoadingState extends MosaicoStoreState {
  @override
  List<Object> get props => [];
}

class MosaicoStoreLoadedState extends MosaicoStoreState {
  final int? installingWidgetId;
  final List<MosaicoWidget> storeWidgets;
  final List<MosaicoWidget> installedWidgets;

  MosaicoStoreLoadedState({required this.storeWidgets, required this.installedWidgets, this.installingWidgetId});

  @override
  List<Object> get props => [storeWidgets, installingWidgetId ?? 0];
}

class MosaicoStoreErrorState extends MosaicoStoreState {
  final String message;

  MosaicoStoreErrorState({required this.message});

  @override
  List<Object> get props => [message];
}