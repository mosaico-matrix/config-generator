import '../../../../core/models/serializable.dart';

class MosaicoWidgetConfiguration implements Serializable {
  final int? id;
  final String name;

  MosaicoWidgetConfiguration({
     this.id,
    required this.name,
  });

  factory MosaicoWidgetConfiguration.fromJson(Map<String, dynamic> json) {
    return MosaicoWidgetConfiguration(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}