import 'package:mosaico_flutter_core/modules/networking/models/serializable.dart';

class Widget implements Serializable {
  final int id;
  final String name;
  final String author;

  Widget({
    required this.id,
    required this.name,
    required this.author,
  });

  factory Widget.fromJson(Map<String, dynamic> json) {
    return Widget(
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