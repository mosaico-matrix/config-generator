import 'dart:convert';
import 'dart:io';

import 'package:mosaico_flutter_core/core/networking/services/coap/coap_service.dart';

import '../../../../core/networking/services/rest/rest_service.dart';
import '../../domain/repositories/mosaico_widgets_repository.dart';
import '../models/mosaico_widget.dart';

class MosaicoWidgetsRepositoryImpl implements MosaicoWidgetsRepository {

  static const String _baseCoapUri = '/widgets';
  static const String _baseRestUri = 'widgets';

  @override
  Future<List<MosaicoWidget>> getStoreWidgets({String? search, String? category, int page = 1}) async {
    var data = await RestService.get(_baseRestUri);
    return List<MosaicoWidget>.from(data.map((widget) => MosaicoWidget.fromStoreJson(widget)));
  }

  @override
  Future<void> installWidget({required int storeId}) async {
    await CoapService.post(_baseCoapUri + '/installed/widget_store_id=$storeId', '');
  }

  @override
  Future<void> uninstallWidget({required int widgetId}) async {
    await CoapService.delete(_baseCoapUri + '/installed/widget_id=$widgetId');
  }

  @override
  Future<List<MosaicoWidget>> getInstalledWidgets() async {
    final data = await CoapService.get(_baseCoapUri + '/installed/'); // note the trailing slash, coap returns 404 otherwise
    return List<MosaicoWidget>.from(data.map((widget) => MosaicoWidget.fromJson(widget)));
  }

  @override
  Future<void> previewWidget({required int widgetId, int? configurationId}) async {
    await CoapService.post(
        _baseCoapUri + '/active', '{"widget_id": $widgetId, "config_id": $configurationId}');
  }

  @override
  Future<Map<String, dynamic>> getWidgetConfigurationForm({required int widgetId}) async {
    return await CoapService.get(_baseCoapUri + '/configuration_form/widget_id=$widgetId');
  }

  @override
  Future<MosaicoWidget> installDevelopedWidget({required String projectName, required String archivePath}) async {

    final file = File(archivePath);
    final fileBase64 = base64Encode(await file.readAsBytes());

    // Send the configuration to the matrix
    final data = await CoapService.post(_baseCoapUri + '/developed', '$projectName,$fileBase64');
    return MosaicoWidget.fromJson(data);
  }
}
