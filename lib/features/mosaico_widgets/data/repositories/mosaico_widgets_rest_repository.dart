import '../../../../core/networking/services/rest/rest_service.dart';
import '../models/mosaico_widget.dart';

class MosaicoWidgetsRestRepository  {

  static const String _baseUri = 'widgets';

  Future<List<MosaicoWidget>> getStoreWidgets({String? search, String? category, int page = 1}) async {
    var data = await RestService.get(_baseUri);
    return List<MosaicoWidget>.from(data.map((widget) => MosaicoWidget.fromStoreJson(widget)));
  }

  Future<MosaicoWidget> getWidgetDetails({required int storeId}) async {
    final data = await RestService.get('$_baseUri/$storeId');
    return MosaicoWidget.fromStoreJson(data);
  }
}
