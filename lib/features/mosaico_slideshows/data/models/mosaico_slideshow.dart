import 'package:mosaico_flutter_core/core/models/serializable.dart';

import 'mosaico_slideshow_item.dart';

class MosaicoSlideshow implements Serializable
{
  final id;
  String name;
  List<MosaicoSlideshowItem> items;

  MosaicoSlideshow({this.id = -1, this.name = "New slideshow", List<MosaicoSlideshowItem>? items})
      : items = items ?? [];

  factory MosaicoSlideshow.fromJson(Map<String, dynamic> json)
  {
    return MosaicoSlideshow(
      id: json['id'],
      name: json['name'],
      items: (json['items'] as List).map((item) => MosaicoSlideshowItem.fromJson(item)).toList()
    );
  }

  Map<String, dynamic> toJson()
  {
    return {
      'id': id,
      'name': name,
      'items': items.map((item) => item.toJson()).toList()
    };
  }
}