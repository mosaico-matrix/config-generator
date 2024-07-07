import 'package:mosaico_flutter_core/features/mosaico_slideshows/data/models/mosaico_slideshow.dart';
import 'package:mosaico_flutter_core/features/mosaico_slideshows/data/models/mosaico_slideshow_item.dart';

abstract class MosaicoSlideshowsRepository
{

  /// Returns all the slideshows available on the matrix
  Future<List<MosaicoSlideshow>> getSlideshows();

  /// Creates a new slideshow with the given items
  /// It can also be used to update an existing slideshow when the id is set
  Future<MosaicoSlideshow> createOrUpdateSlideshow(MosaicoSlideshow slideshow);

  /// Sets the given slideshow as the active slideshow
  Future<void> setActiveSlideshow(MosaicoSlideshow slideshow);
}