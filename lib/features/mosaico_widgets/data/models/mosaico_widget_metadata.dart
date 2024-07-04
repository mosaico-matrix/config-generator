import 'package:mosaico_flutter_core/core/models/serializable.dart';

class MosaicoWidgetMetadata implements Serializable {
  MosaicoWidgetMetadata({
    required this.name,
    required this.description,
    required this.version,
    required this.softwareVersion,
    required this.author,
    required this.fps,
    required this.configurable,
  });

  final String name;
  final String description;
  final String version;
  final String softwareVersion;
  final String author;
  final int fps;
  final bool configurable;

  factory MosaicoWidgetMetadata.fromJson(Map<String, dynamic> json) {
    return MosaicoWidgetMetadata(
        name: json['name'],
        description: json['description'],
        version: json['version'],
        softwareVersion: json['software_version'],
        author: json['author'],
        fps: json['fps'],
        configurable: json['configurable']);
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
