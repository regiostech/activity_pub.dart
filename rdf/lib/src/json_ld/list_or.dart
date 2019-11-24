class ListOr<T> {
  T _single;
  List<T> _list;

  ListOr.single(this._single);

  ListOr.list(Iterable<T> list) : _list = list.toList();

  bool get isList => _list != null;

  bool get isSingle => !isList;

  T get asSingle => _single;

  List<T> get asList => _list;
}
