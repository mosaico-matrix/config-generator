import 'package:flutter/cupertino.dart';

import '../../data/models/mosaico_widget.dart';
import '../../data/models/mosaico_widget_configuration.dart';

abstract class MosaicoLocalWidgetsRepository {

  /// Install a widget from the app store
  Future<void> installWidget({required int storeId});

  /// Uninstall a widget previously installed
  Future<void> uninstallWidget({required int widgetId});

  /// Get a list of all installed widgets
  Future<List<MosaicoWidget>> getInstalledWidgets();

  /// Set a widget as active on the matrix
  Future<void> previewWidget({required int widgetId, int? configurationId});

  /// Unset the active widget on the matrix
  Future<void> unsetActiveWidget();

  /// Get the active widget on the matrix
  Future<(MosaicoWidget?, MosaicoWidgetConfiguration?)> getActiveWidget();

  /// Get the configuration form for a widget, used to create a new widget configuration
  Future<Map<String, dynamic>> getWidgetConfigurationForm({required int widgetId});

  /// Install a locally developed widget and returns the result
  Future<MosaicoWidget> installDevelopedWidget({required String projectName, required String archivePath});
}
