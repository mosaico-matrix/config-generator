import 'package:mosaico_flutter_core/features/mosaico_slideshows/data/models/mosaico_slideshow.dart';
import 'package:mosaico_flutter_core/features/mosaico_slideshows/data/models/mosaico_slideshow_item.dart';

abstract class MosaicoSlideshowsRepository
{

  /// Returns all the slideshows available on the matrix
  Future<List<MosaicoSlideshow>> getSlideshows();

  /// Creates a new slideshow with the given items
  Future<MosaicoSlideshow> createSlideshow(MosaicoSlideshow slideshow);
}