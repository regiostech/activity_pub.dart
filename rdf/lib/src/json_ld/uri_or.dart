class UriOr<T> {
  T _value;
  Uri _uri;

  UriOr._(this._value, this._uri);

  UriOr.value(this._value);

  UriOr.uri(this._uri);

  bool get isUri => _uri != null;

  bool get isValue => !isUri;

  T get asValue => _value;

  Uri get asUri => _uri;

  UriOr<T> copy() => UriOr._(_value, _uri);

  @override
  String toString() => _uri?.toString() ?? _value.toString();
}
