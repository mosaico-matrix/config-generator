import 'package:mosaico_flutter_core/modules/networking/models/serializable.dart';

class MosaicoWidget implements Serializable {
  final int id;
  final String name;
  final String author;

  MosaicoWidget({
    required this.id,
    required this.name,
    required this.author,
  });

  factory MosaicoWidget.fromJson(Map<String, dynamic> json) {
    return MosaicoWidget(
      id: json['id'],
      name: json['name'],
      author: json['author'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'author': author,
    };
  }
}