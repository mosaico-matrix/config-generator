import 'dart:convert';
import 'package:mosaico_flutter_core/core/utils/toaster.dart';

import '../../models/widget.dart';
import 'base_service.dart';

class WidgetsService {

  static const String _baseUri = '/widgets';

  /**
   * installed
   */
  static const String _installedUri = _baseUri + '/installed';

  static Future<void> installWidget(int id) async {
    await BaseService.post(_installedUri, '{"widget_store_id": $id}');
  }

  static Future<List<Widget>> getInstalledWidgets() async {
    final data = await BaseService.get(_installedUri);
    return List<Widget>.from(data.map((widget) => Widget.fromJson(widget)));
  }

  /**
   * active_widget
   */
  static const String _activeWidgetUri = _baseUri + '/active';

  static Future<void> previewWidget(int widgetId, int configId) async {
    await BaseService.post(
        _activeWidgetUri, '{"widget_id": $widgetId, "config_id": $configId}');
  }


  /**
   * widget_configuration_form
   */
  static const String _widgetConfigurationFormUri = _baseUri + '/configuration_form';


  static Future<Map<String, dynamic>> getWidgetConfigurationForm(int widgetId) async {
    final data = await BaseService.get(_widgetConfigurationFormUri + '/widget_id=$widgetId');
    return data;
  }

}
