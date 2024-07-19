import 'package:mosaico_flutter_core/core/models/serializable.dart';

class MosaicoWidgetMetadata implements Serializable {
  MosaicoWidgetMetadata({
    required this.name,
    required this.description,
    required this.widgetVersion,
    required this.softwareVersion,
    required this.fps,
    required this.configurable,
  });

  final String name;
  final String description;
  final String widgetVersion;
  final String softwareVersion;
  final int fps;
  final bool configurable;

  factory MosaicoWidgetMetadata.fromJson(Map<String, dynamic> json) {
    return MosaicoWidgetMetadata(
        name: json['name'],
        description: json['description'],
        widgetVersion: json['widget_version'],
        softwareVersion: json['software_version'],
        fps: json['fps'],
        configurable:json['configurable']);
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
