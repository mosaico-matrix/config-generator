import 'dart:convert';
import 'dart:io';

import 'package:mosaico_flutter_core/core/networking/services/coap/coap_service.dart';

import '../../../../core/networking/services/rest/rest_service.dart';
import '../../domain/repositories/mosaico_local_widgets_repository.dart';
import '../../domain/repositories/mosaico_widgets_repository.dart';
import '../models/mosaico_widget.dart';
import '../models/mosaico_widget_configuration.dart';

class MosaicoWidgetsCoapRepository implements MosaicoLocalWidgetsRepository {

  static const String _baseUri = '/widgets';

  @override
  Future<void> installWidget({required int storeId}) async {
    await CoapService.post(_baseUri + '/installed/widget_store_id=$storeId', '');
  }

  @override
  Future<void> uninstallWidget({required int widgetId}) async {
    await CoapService.delete(_baseUri + '/installed/widget_id=$widgetId');
  }

  @override
  Future<List<MosaicoWidget>> getInstalledWidgets() async {
    final data = await CoapService.get(_baseUri + '/installed/1=1');
    return List<MosaicoWidget>.from(data.map((widget) => MosaicoWidget.fromJson(widget)));
  }

  @override
  Future<void> previewWidget({required int widgetId, int? configurationId}) async {
    await CoapService.post(
        _baseUri + '/active', '{"widget_id": $widgetId, "config_id": $configurationId}');
  }

  @override
  Future<void> unsetActiveWidget() async {
    await CoapService.delete(_baseUri + '/active');
  }

  @override
  Future<(MosaicoWidget?, MosaicoWidgetConfiguration?)> getActiveWidget() async {
    var result = await CoapService.get(_baseUri + '/active');
    return (
        result['widget'] == null ? null : MosaicoWidget.fromJson(result['widget']),
        result['config'] == null ? null : MosaicoWidgetConfiguration.fromJson(result['config']));
  }

  @override
  Future<Map<String, dynamic>> getWidgetConfigurationForm({required int widgetId}) async {
    return await CoapService.get(_baseUri + '/configuration_form/widget_id=$widgetId');
  }

  @override
  Future<MosaicoWidget> installDevelopedWidget({required String projectName, required String archivePath}) async {

    final file = File(archivePath);
    final fileBase64 = base64Encode(await file.readAsBytes());

    // Send the configuration to the matrix
    final data = await CoapService.post(_baseUri + '/developed', '$projectName,$fileBase64');
    return MosaicoWidget.fromJson(data);
  }


}
