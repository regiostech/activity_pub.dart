class UriOr<T> {
  T _value;
  Uri _uri;

  UriOr.value(this._value);

  UriOr.uri(this._uri);

  bool get isUri => _uri != null;

  bool get isValue => !isUri;

  T get asValue => _value;

  Uri get asUri => _uri;
}
