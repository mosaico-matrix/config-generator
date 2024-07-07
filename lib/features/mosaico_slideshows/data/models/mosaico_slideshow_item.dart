import '../../../../core/models/serializable.dart';

class MosaicoSlideshowItem implements Serializable
{
  int id;
  int widgetId;
  int configId;
  int position;
  int secondsDuration;

  MosaicoSlideshowItem({
    this.id = -1,
    this.widgetId = -1,
    this.configId = -1,
    this.position= 0,
    this.secondsDuration=30,
  });

  factory MosaicoSlideshowItem.fromJson(Map<String, dynamic> json)
  {
    return MosaicoSlideshowItem(
      id: json['id'],
      widgetId: json['widgetId'],
      configId: json['configId'],
      position: json['position'],
      secondsDuration: json['secondsDuration']
    );
  }

  Map<String, dynamic> toJson()
  {
    return {
      'id': id,
      'widgetId': widgetId,
      'configId': configId,
      'position': position,
      'secondsDuration': secondsDuration
    };
  }

}