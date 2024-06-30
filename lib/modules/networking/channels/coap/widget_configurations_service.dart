import 'dart:convert';
import 'dart:io';
import 'package:mosaico_flutter_core/core/utils/toaster.dart';

import '../../models/mosaico_widget.dart';
import '../../models/widget_configuration.dart';
import 'base_service.dart';

class WidgetConfigurationsService {

  static Future<void> uploadWidgetConfiguration(int widgetId, String configurationName, String configurationArchivePath) async {

    // Convert the configuration file to base64
    final file = File(configurationArchivePath);
    final bytes = await file.readAsBytes();
    final base64 = base64Encode(bytes);

    // Send the configuration to the matrix
    await BaseService.post('/widget_configurations/widget_id=$widgetId', '$configurationName,$base64');
  }

  static Future<List<WidgetConfiguration>> getWidgetConfigurations(int widgetId) async {
    final response = await BaseService.get('/widget_configurations/widget_id=$widgetId');
    return (response as List).map((e) => WidgetConfiguration.fromJson(e)).toList();
  }

  static Future<void> deleteWidgetConfiguration(int configurationId) async {
    await BaseService.delete('/widget_configurations/configuration_id=$configurationId');
  }

}
