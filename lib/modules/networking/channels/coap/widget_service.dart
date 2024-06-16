import 'dart:convert';
import 'package:mosaico_flutter_core/toaster.dart';

import '../../models/widget.dart';
import 'base_service.dart';

class WidgetService {

  static Future<void> installWidget(int id) async {
    await BaseService.post('/installed_widgets', '{"id": $id}');
  }

  static Future<List<Widget>> getInstalledWidgets() async {
    final data = await BaseService.get('/installed_widgets');
    return List<Widget>.from(data.map((widget) => Widget.fromJson(widget)));
  }

  static Future<void> previewWidget(int widgetId, int configId) async {
    await BaseService.post('/active_widget', '{"widget_id": $widgetId, "config_id": $configId}');
  }

}
