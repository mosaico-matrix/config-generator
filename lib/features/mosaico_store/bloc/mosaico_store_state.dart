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
  final List<MosaicoWidget> widgets;

  MosaicoStoreLoadedState({required this.widgets});

  @override
  List<Object> get props => [widgets];
}

class MosaicoStoreErrorState extends MosaicoStoreState {
  final String message;

  MosaicoStoreErrorState({required this.message});

  @override
  List<Object> get props => [message];
}