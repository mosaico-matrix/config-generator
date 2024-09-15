
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mosaico_flutter_core/features/mosaico_widgets/bloc/mosaico_installed_widgets_event.dart';
import 'package:mosaico_flutter_core/features/mosaico_widgets/bloc/mosaico_installed_widgets_state.dart';
import 'package:mosaico_flutter_core/features/mosaico_widgets/data/repositories/mosaico_widgets_coap_repository.dart';

class MosaicoInstalledWidgetsBloc extends Bloc<MosaicoInstalledWidgetsEvent, MosaicoInstalledWidgetsState>
{
  final MosaicoWidgetsCoapRepository repository;
  MosaicoInstalledWidgetsBloc({required this.repository}) : super(MosaicoInstalledWidgetsInitial())
  {
    on<LoadInstalledWidgetsEvent>(_onLoadInstalledWidgets);
  }

  Future<void> _onLoadInstalledWidgets(LoadInstalledWidgetsEvent event, Emitter<MosaicoInstalledWidgetsState> emit) async {
    emit(MosaicoInstalledWidgetsLoading());

    try {
      final installedWidgets = await repository.getInstalledWidgets();
      emit(MosaicoInstalledWidgetsLoaded(installedWidgets));
    } catch (e) {
      emit(MosaicoInstalledWidgetsError("Error loading installed widgets"));
    }
  }
}