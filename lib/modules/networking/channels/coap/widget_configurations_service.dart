import 'dart:convert';
import 'dart:io';
import 'package:mosaico_flutter_core/toaster.dart';

import '../../models/widget.dart';
import 'base_service.dart';

class WidgetConfigurationsService {

  static Future<void> uploadWidgetConfiguration(int widgetId, String configurationName, String configurationArchivePath) async {

    // Convert the configuration file to base64
    final file = File(configurationArchivePath);
    final bytes = await file.readAsBytes();
    final base64 = base64Encode(bytes);

    // Send the configuration to the matrix
    await BaseService.post('/widget_configurations', '$widgetId,$configurationName,$base64');
  }

}
