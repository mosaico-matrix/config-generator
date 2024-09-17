import 'dart:convert';
import 'dart:io';

import 'package:mosaico_flutter_core/core/networking/services/coap/coap_service.dart';
import '../models/mosaico_widget.dart';
import '../models/mosaico_widget_configuration.dart';

class MosaicoWidgetsCoapRepository {

  static const String _baseUri = '/widgets';

  // Memory cache to prevent multiple requests
  List<MosaicoWidget> _installedWidgets = [];

  Future<MosaicoWidget> installWidget({required int storeId}) async {
    var result = await CoapService.post(_baseUri + '/installed/widget_store_id=$storeId', '');
    var installedWidget = MosaicoWidget.fromJson(result);
    _installedWidgets.add(installedWidget);
    return installedWidget;
  }

  Future<void> uninstallWidget({required int widgetId}) async {
    await CoapService.delete(_baseUri + '/installed/widget_id=$widgetId');
    _installedWidgets.removeWhere((element) => element.id == widgetId);
  }

  Future<List<MosaicoWidget>> getInstalledWidgets() async {
    if (_installedWidgets.isNotEmpty) {
      return _installedWidgets;
    }
    final data = await CoapService.get(_baseUri + '/installed/1=1');
    var widgets = List<MosaicoWidget>.from(data.map((widget) => MosaicoWidget.fromJson(widget)));
    _installedWidgets = widgets;
    return widgets;
  }

  Future<void> previewWidget({required int widgetId, int? configurationId}) async {
    await CoapService.post(
        _baseUri + '/active', '{"widget_id": $widgetId, "config_id": $configurationId}');
  }


  Future<void> unsetActiveWidget() async {
    await CoapService.delete(_baseUri + '/active');
  }


  Future<(MosaicoWidget?, MosaicoWidgetConfiguration?)> getActiveWidget() async {
    var result = await CoapService.get(_baseUri + '/active');
    return (
        result['widget'] == null ? null : MosaicoWidget.fromJson(result['widget']),
        result['config'] == null ? null : MosaicoWidgetConfiguration.fromJson(result['config']));
  }

  Future<Map<String, dynamic>> getWidgetConfigurationForm({required int widgetId}) async {
    return await CoapService.get(_baseUri + '/configuration_form/widget_id=$widgetId');
  }

  Future<MosaicoWidget> installDevelopedWidget({required String projectName, required String archivePath}) async {

    final file = File(archivePath);
    final fileBase64 = base64Encode(await file.readAsBytes());

    // Send the configuration to the matrix
    final data = await CoapService.post(_baseUri + '/developed', '$projectName,$fileBase64');
    var widget = MosaicoWidget.fromJson(data);
    _installedWidgets.add(widget);
    return widget;
  }

  List<MosaicoWidget> getInstalledWidgetsFromCache() {
    return _installedWidgets;
  }

  MosaicoWidget? getByIdFromCache(int id) {
    for (var widget in _installedWidgets) {
      if (widget.id == id) {
        return widget;
      }
    }
    return null;
  }

  void clearCache() {
    _installedWidgets = [];
  }

}
