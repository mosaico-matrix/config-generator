import '../../../../core/models/serializable.dart';

class MosaicoSlideshowItem implements Serializable
{
  int id;
  int widgetId;
  int? configId;
  int position;
  int secondsDuration;


  MosaicoSlideshowItem({
    this.id = -1,
    this.widgetId = -1,
    this.configId,
    this.position= 0,
    this.secondsDuration=0,
  });

  factory MosaicoSlideshowItem.fromJson(Map<String, dynamic> json)
  {
    return MosaicoSlideshowItem(
      id: json['id'],
      widgetId: json['widget_id'],
      configId: json['config_id'],
      position: json['position'],
      secondsDuration: json['seconds_duration']
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

  MosaicoSlideshowItem copyWith({
    int? id,
    int? widgetId,
    required int? configId,
    int? position,
    int? secondsDuration,
  }) {
    return MosaicoSlideshowItem(
      id: id ?? this.id,
      widgetId: widgetId ?? this.widgetId,
      configId: configId,
      position: position ?? this.position,
      secondsDuration: secondsDuration ?? this.secondsDuration,
    );
  }

}