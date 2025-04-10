class FirebaseServerException implements Exception {
  final String message;

  FirebaseServerException(this.message);
}

class GraphqlServerException implements Exception {
  final String message;

  GraphqlServerException(this.message);
}
