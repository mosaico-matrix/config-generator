import 'package:equatable/equatable.dart';
import 'package:mosaico_flutter_core/features/mosaico_widgets/data/models/mosaico_widget.dart';

abstract class MosaicoInstalledWidgetsState extends Equatable {}

class MosaicoInstalledWidgetsInitial extends MosaicoInstalledWidgetsState {
  @override
  List<Object> get props => [];
}

class MosaicoInstalledWidgetsLoading extends MosaicoInstalledWidgetsState {
  @override
  List<Object> get props => [];
}

class MosaicoInstalledWidgetsLoaded extends MosaicoInstalledWidgetsState {
  final List<MosaicoWidget> installedWidgets;

  MosaicoInstalledWidgetsLoaded(this.installedWidgets);

  @override
  List<Object> get props => [installedWidgets];
}

class MosaicoInstalledWidgetsError extends MosaicoInstalledWidgetsState {
  final String message;

  MosaicoInstalledWidgetsError(this.message);

  @override
  List<Object> get props => [message];
}