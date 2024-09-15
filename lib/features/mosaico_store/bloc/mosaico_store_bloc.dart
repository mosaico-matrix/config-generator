import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mosaico_flutter_core/features/mosaico_store/bloc/mosaico_store_event.dart';
import 'package:mosaico_flutter_core/features/mosaico_store/bloc/mosaico_store_state.dart';
import 'package:mosaico_flutter_core/features/mosaico_widgets/bloc/mosaico_installed_widgets_event.dart';
import 'package:mosaico_flutter_core/features/mosaico_widgets/bloc/mosaico_installed_widgets_state.dart';
import 'package:mosaico_flutter_core/features/mosaico_widgets/data/repositories/mosaico_widgets_coap_repository.dart';
import 'package:mosaico_flutter_core/features/mosaico_widgets/data/repositories/mosaico_widgets_rest_repository.dart';

class MosaicoStoreBloc extends Bloc<MosaicoStoreEvent, MosaicoStoreState> {

  final MosaicoWidgetsRestRepository widgetsRestRepository;
  MosaicoStoreBloc({required this.widgetsRestRepository}) : super(MosaicoStoreInitialState())
  {
    on<LoadMosaicoStoreEvent>(_onLoadMosaicoStoreEvent);
  }

  Future<void> _onLoadMosaicoStoreEvent(LoadMosaicoStoreEvent event, Emitter<MosaicoStoreState> emit) async {
    emit(MosaicoStoreLoadingState());
    try {
      var widgets = await widgetsRestRepository.getStoreWidgets();
      emit(MosaicoStoreLoadedState(widgets: widgets));
    } catch (e) {
      emit(MosaicoStoreErrorState(message: "Error loading store widgets"));
    }
  }
}