import 'package:mosaico_flutter_core/features/mosaico_widgets/data/models/mosaico_widget_configuration.dart';

abstract class MosaicoWidgetConfigurationsRepository {


  /// Get a list of all widget configurations for a widget
  /// [widgetId]: id of the widget to get configurations for
  Future<List<MosaicoWidgetConfiguration>> getWidgetConfigurations({required int widgetId});

  /// Upload a new widget configuration for a widget
  Future<MosaicoWidgetConfiguration> uploadWidgetConfiguration({required int widgetId, required String configurationName, required String configurationArchivePath});

  /// Updates an existing widget configuration
  Future<MosaicoWidgetConfiguration> updateWidgetConfiguration({required int configurationId, required String configurationName, required String configurationArchivePath});

  /// Delete a widget configuration
  Future<void> deleteWidgetConfiguration({required int configurationId});

  /// Get widget configuration package
  /// Returns the path to the configuration package saved in a temp folder
  Future<String> getWidgetConfigurationPackage({required int configurationId});
}
