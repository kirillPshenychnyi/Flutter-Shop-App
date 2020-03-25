class HttpException implements Exception {
  String _message;

  HttpException(this._message);

  @override
  String toString() {
    return _message;
  }
}