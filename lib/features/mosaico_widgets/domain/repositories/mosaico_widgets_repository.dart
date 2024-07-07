import 'package:flutter/cupertino.dart';

import '../../data/models/mosaico_widget.dart';
import '../../data/models/mosaico_widget_configuration.dart';

abstract class MosaicoWidgetsRepository {

  /// Get a list of all widgets available in the app store
  /// [search]: search string to filter widgets
  /// [category]: category to filter widgets
  /// [page]: page number to get
  Future<List<MosaicoWidget>> getStoreWidgets({String? search, String? category, int page = 1});

  /// Get widget details from the app store
  /// [storeId]: the id of the widget in the app store
  Future<MosaicoWidget> getWidgetDetails({required int storeId});
}
