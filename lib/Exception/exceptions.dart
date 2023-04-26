class InvalidArgumentException implements Exception {
  final String code;
  final String details;

  InvalidArgumentException(this.code, this.details);
}

class UnknownException implements Exception {
  final String code;
  final String details;

  UnknownException(this.code, this.details);
}
