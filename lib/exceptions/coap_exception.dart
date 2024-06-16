class CoapException implements Exception {
  final String message;

  CoapException({this.message = 'An error occurred, check your connection with the matrix'});

  @override
  String toString() {
    return message;
  }
}