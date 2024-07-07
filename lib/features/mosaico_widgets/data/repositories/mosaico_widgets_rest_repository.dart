import 'dart:convert';
import 'dart:io';

import 'package:mosaico_flutter_core/core/networking/services/coap/coap_service.dart';

import '../../../../core/networking/services/rest/rest_service.dart';
import '../../domain/repositories/mosaico_widgets_repository.dart';
import '../models/mosaico_widget.dart';
import '../models/mosaico_widget_configuration.dart';

class MosaicoWidgetsRestRepository implements MosaicoWidgetsRepository {

  static const String _baseUri = 'widgets';

  @override
  Future<List<MosaicoWidget>> getStoreWidgets({String? search, String? category, int page = 1}) async {
    var data = await RestService.get(_baseUri);
    return List<MosaicoWidget>.from(data.map((widget) => MosaicoWidget.fromStoreJson(widget)));
  }

  @override
  Future<MosaicoWidget> getWidgetDetails({required int storeId}) async {
    final data = await RestService.get('$_baseUri/$storeId');
    return MosaicoWidget.fromStoreJson(data);
  }
}
