import 'package:mosaico_flutter_core/features/mosaico_slideshows/data/models/mosaico_slideshow.dart';
import '../../../../core/networking/services/coap/coap_service.dart';
import '../../domain/repositories/mosaico_slideshows_repository.dart';

class MosaicoSlideshowsCoapRepository implements MosaicoSlideshowsRepository
{
  String _baseUri = 'slideshows/created';

  @override
  Future<List<MosaicoSlideshow>> getSlideshows() async {
    return await CoapService.get(_baseUri);
  }

  @override
  Future<MosaicoSlideshow> createSlideshow(MosaicoSlideshow slideshow) async {
    return await CoapService.post(_baseUri, slideshow.toJson().toString());
  }
}