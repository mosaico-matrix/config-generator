import '../../../../core/models/serializable.dart';

class MosaicoWidget implements Serializable {
  final int id;
  final int? storeId;
  final String name;
  final String author;
  final String description;
  bool installed = false;

  MosaicoWidget({
    required this.id,
    this.storeId,
    required this.name,
    required this.author,
    required this.description,
  });

  /// This is used when deserializing COAP responses
  factory MosaicoWidget.fromJson(Map<String, dynamic> json) {
    return MosaicoWidget(
      id: json['id'],
      storeId: json['store_id'],
      name: json['name'],
      author: json['author'],
      description: ''
    );
  }

  /// This is used when deserializing REST responses
  factory MosaicoWidget.fromStoreJson(Map<String, dynamic> json) {
    return MosaicoWidget(
      id: json['id'],
      storeId: json['id'],
      name: json['name'],
      author: json['user']['username'],
      description: json['description'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }


}