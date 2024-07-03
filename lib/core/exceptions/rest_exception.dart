class RestException implements Exception {
  final String message;
  final int code;

  RestException(this.message, this.code);
}