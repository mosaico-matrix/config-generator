import 'package:mosaico_flutter_core/features/mosaico_slideshows/data/models/mosaico_slideshow.dart';
import '../../../../core/networking/services/coap/coap_service.dart';
import 'dart:convert';

class MosaicoSlideshowsCoapRepository {
  final String _baseUri = 'slideshows';

  // In-memory cache for slideshows, initialized as an empty list
  List<MosaicoSlideshow> _slideshowsCache = [];

  Future<List<MosaicoSlideshow>> getSlideshows() async {
    // Return the cache if available (non-empty)
    if (_slideshowsCache.isNotEmpty) {
      return _slideshowsCache;
    }

    // Fetch from the service if cache is empty
    var result = await CoapService.get(_baseUri + '/created/1=1');
    _slideshowsCache = (result as List)
        .map((json) => MosaicoSlideshow.fromJson(json))
        .toList();

    return _slideshowsCache;
  }

  Future<MosaicoSlideshow> createOrUpdateSlideshow(
      MosaicoSlideshow slideshow) async {
    var result =
    await CoapService.post(_baseUri + '/created/', jsonEncode(slideshow));
    var createdSlideshow = MosaicoSlideshow.fromJson(result);

    // Check if the slideshow with the same ID is already in the cache
    var index = _slideshowsCache.indexWhere((element) => element.id == createdSlideshow.id);

    // Update cache
    if (index != -1) {
      _slideshowsCache[index] = createdSlideshow;
    } else {
      _slideshowsCache.add(createdSlideshow);
    }

    return createdSlideshow;
  }

  Future<void> setActiveSlideshow(int slideshowId) async {
    await CoapService.post(
        _baseUri + '/active', '{"slideshow_id": $slideshowId}');
  }

  Future<void> deleteSlideshow(int slideshowId) async {
    await CoapService.delete(_baseUri + '/created/slideshow_id=$slideshowId');

    // Remove slideshow from cache
    _slideshowsCache.removeWhere((element) => element.id == slideshowId);
  }

  // Method to clear the cache manually
  void clearCache() {
    _slideshowsCache.clear();
  }
}
