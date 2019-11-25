class JsonLDException implements Exception {
  final String code;
  final String message;

  JsonLDException(this.code, {this.message});

  @override
  String toString() {
    var b = StringBuffer('JSON-LD error($code)');
    if (message != null) {
      b.write(': $message');
    }
    return b.toString();
  }
}
