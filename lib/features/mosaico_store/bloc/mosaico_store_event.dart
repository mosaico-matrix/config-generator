import 'package:equatable/equatable.dart';
import 'package:mosaico_flutter_core/features/mosaico_store/bloc/mosaico_store_state.dart';
import 'package:mosaico_flutter_core/features/mosaico_widgets/data/models/mosaico_widget.dart';

abstract class MosaicoStoreEvent extends Equatable {}

class LoadMosaicoStoreEvent extends MosaicoStoreEvent {
  @override
  List<Object> get props => [];
}

class InstallMosaicoWidgetEvent extends MosaicoStoreEvent {
  final int storeId;
  final MosaicoStoreLoadedState previousState;

  InstallMosaicoWidgetEvent({required this.storeId, required this.previousState});

  @override
  List<Object> get props => [storeId, previousState];
}