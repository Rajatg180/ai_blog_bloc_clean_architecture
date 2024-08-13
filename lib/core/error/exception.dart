
// custom exception for server error

class ServerException implements Exception {
  final String message;

  ServerException(this.message);
}