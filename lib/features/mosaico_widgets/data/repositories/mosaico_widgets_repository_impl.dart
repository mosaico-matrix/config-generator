import 'dart:convert';

import 'package:mosaico_flutter_core/core/networking/services/coap/coap_service.dart';

import '../../domain/repositories/mosaico_widgets_repository.dart';
import '../models/mosaico_widget.dart';

class MosaicoWidgetsRepositoryImpl implements MosaicoWidgetsRepository {

  static const String _baseUri = '/widgets';

  @override
  Future<List<MosaicoWidget>> getWidgets({String? search, String? category, int page = 1}) async {
    // USE REST HERE
    // Implement logic to fetch widgets from the app store
    // Example: You can use search, category, and page parameters
    // Example: final data = await BaseService.get(_baseUri + '/widgets?search=$search&category=$category&page=$page');
    // Example: return List<MosaicoWidget>.from(data.map((widget) => MosaicoWidget.fromJson(widget)));
    throw UnimplementedError();
  }

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
    final data = await CoapService.get(_baseUri + '/installed');
    return List<MosaicoWidget>.from(data.map((widget) => MosaicoWidget.fromJson(widget)));
  }

  @override
  Future<void> previewWidget({required int widgetId, int? configurationId}) async {
    await CoapService.post(
        _baseUri + '/active', '{"widget_id": $widgetId, "config_id": $configurationId ?? 0}');
  }

  @override
  Future<Map<String, dynamic>> getWidgetConfigurationForm({required int widgetId}) async {
    return await CoapService.get(_baseUri + '/configuration_form/widget_id=$widgetId');
  }
}
