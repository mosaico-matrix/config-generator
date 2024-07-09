import 'package:mosaico_flutter_core/features/mosaico_slideshows/data/models/mosaico_slideshow.dart';
import '../../../../core/networking/services/coap/coap_service.dart';
import '../../domain/repositories/mosaico_slideshows_repository.dart';
import 'dart:convert';


class MosaicoSlideshowsCoapRepository implements MosaicoSlideshowsRepository
{
  String _baseUri = 'slideshows';

  @override
  Future<List<MosaicoSlideshow>> getSlideshows() async {
    var result = await CoapService.get(_baseUri + '/created/');
    return (result as List).map((json) => MosaicoSlideshow.fromJson(json)).toList();
  }

  @override
  Future<MosaicoSlideshow> createOrUpdateSlideshow(MosaicoSlideshow slideshow) async {
    var result = await CoapService.post(_baseUri + '/created/', jsonEncode(slideshow));
    return MosaicoSlideshow.fromJson(result);
  }

  @override
  Future<void> setActiveSlideshow(int slideshowId) async {
    await CoapService.post(
        _baseUri + '/active','{"slideshow_id": ${slideshowId}}');
  }

  @override
  Future<void> deleteSlideshow(int slideshowId) async {
    await CoapService.delete(_baseUri + '/created/slideshow_id=$slideshowId');
  }
}