import 'package:mosaico_flutter_core/modules/networking/models/serializable.dart';

class WidgetConfiguration implements Serializable {
  final int id;
  final String name;

  WidgetConfiguration({
    required this.id,
    required this.name,
  });

  factory WidgetConfiguration.fromJson(Map<String, dynamic> json) {
    return WidgetConfiguration(
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