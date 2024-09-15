import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mosaico_flutter_core/core/utils/toaster.dart';
import 'package:mosaico_flutter_core/features/mosaico_store/bloc/mosaico_store_event.dart';
import 'package:mosaico_flutter_core/features/mosaico_store/bloc/mosaico_store_state.dart';
import 'package:mosaico_flutter_core/features/mosaico_widgets/bloc/mosaico_installed_widgets_event.dart';
import 'package:mosaico_flutter_core/features/mosaico_widgets/bloc/mosaico_installed_widgets_state.dart';
import 'package:mosaico_flutter_core/features/mosaico_widgets/data/models/mosaico_widget.dart';
import 'package:mosaico_flutter_core/features/mosaico_widgets/data/repositories/mosaico_widgets_coap_repository.dart';
import 'package:mosaico_flutter_core/features/mosaico_widgets/data/repositories/mosaico_widgets_rest_repository.dart';

class MosaicoStoreBloc extends Bloc<MosaicoStoreEvent, MosaicoStoreState> {
  final MosaicoWidgetsRestRepository widgetsRestRepository;
  final MosaicoWidgetsCoapRepository widgetsCoapRepository;

  MosaicoStoreBloc(
      {required this.widgetsRestRepository,
      required this.widgetsCoapRepository})
      : super(MosaicoStoreInitialState()) {
    on<LoadMosaicoStoreEvent>(_onLoadMosaicoStoreEvent);
    on<InstallMosaicoWidgetEvent>(_onInstallMosaicoWidgetEvent);
  }

  Future<void> _onLoadMosaicoStoreEvent(
      LoadMosaicoStoreEvent event, Emitter<MosaicoStoreState> emit) async {
    emit(MosaicoStoreLoadingState());
    try {
      var storeWidgets = await widgetsRestRepository.getStoreWidgets();
      var installedWidgets = await widgetsCoapRepository.getInstalledWidgets();
      emit(MosaicoStoreLoadedState(
          storeWidgets: storeWidgets, installedWidgets: installedWidgets));
    } catch (e) {
      emit(MosaicoStoreErrorState(message: "Error loading store widgets"));
    }
  }

  Future<void> _onInstallMosaicoWidgetEvent(
      InstallMosaicoWidgetEvent event, Emitter<MosaicoStoreState> emit) async {
    emit(MosaicoStoreLoadedState(
        installingWidgetId: event.storeId,
        storeWidgets: event.previousState.storeWidgets,
        installedWidgets: event.previousState.installedWidgets));
    try {
      var newWidget = await widgetsCoapRepository.installWidget(storeId: event.storeId);
      var installedWidgets = List<MosaicoWidget>.from(event.previousState.installedWidgets);
      installedWidgets.add(newWidget);
      emit(MosaicoStoreLoadedState(
          storeWidgets: event.previousState.storeWidgets,
          installedWidgets: installedWidgets));
    } catch (e) {
      Toaster.error("Error installing widget");
      emit(MosaicoStoreLoadedState(
          storeWidgets: event.previousState.storeWidgets,
          installedWidgets: event.previousState.installedWidgets));
    }
  }
}
