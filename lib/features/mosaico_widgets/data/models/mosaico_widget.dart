import 'dart:convert';

import 'package:mosaico_flutter_core/core/configuration/configs.dart';

import '../../../../core/models/serializable.dart';
import '../../../../core/models/user.dart';
import 'mosaico_widget_configuration.dart';
import 'mosaico_widget_metadata.dart';

class MosaicoWidget implements Serializable {
  final int id;
  final int? storeId;
  final String name;
  final String author;
  final User? user;
  final String description;
  final String tagline;
  String get iconUrl => Configs.apiUrl + '/widgets/$id/icon';
  final List<String>? images;
  bool? installed;
  MosaicoWidgetMetadata? metadata;
  List<MosaicoWidgetConfiguration>? configurations = [];

  MosaicoWidget({
    required this.id,
    this.storeId,
    required this.name,
    required this.author,
    required this.description,
    required this.tagline,
    this.user,
    this.images,
    this.metadata,
    this.installed
  });

  /// This is used when deserializing COAP responses
  factory MosaicoWidget.fromJson(Map<String, dynamic> json) {
    return MosaicoWidget(
      id: json['id'],
      storeId: json['store_id'],
      name: json['name'],
      author: json['author'],
      description: '',
      tagline:'',
      metadata: MosaicoWidgetMetadata.fromJson(jsonDecode(json['metadata'])),
    );
  }

  /// This is used when deserializing REST responses
  factory MosaicoWidget.fromStoreJson(Map<String, dynamic> json) {
    return MosaicoWidget(
      id: json['id'],
      storeId: json['id'],
      name: json['name'],
      author: json['user']['username'],
      user: User.fromJson(json['user']),
      description: json['description'] ?? '',
      tagline: json['tagline'] ?? '',
      images: json['images']?.cast<String>(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }


}