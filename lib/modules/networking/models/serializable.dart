abstract class Serializable {
  factory Serializable.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('fromJson not implemented');
  }
  Map<String, dynamic> toJson();
}
