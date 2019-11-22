import 'package:quiver_hashcode/hashcode.dart';
import 'literal.dart';

class Triple {
  TripleSubject _subject;
  Uri _predicate;
  TripleObject _object;

  TripleSubject get subject => _subject;

  Uri get predicate => _predicate;

  TripleObject get object => _object;

  @override
  int get hashCode => hash3(_subject, _predicate, _object);

  @override
  bool operator ==(other) =>
      other is Triple &&
      _subject == other._subject &&
      _predicate == other._predicate &&
      _object == other._object;
}

class TripleSubject {
  Uri _iri;
  Object _blankNode;

  @override
  int get hashCode => hash2(_iri, _blankNode);

  @override
  bool operator ==(other) =>
      other is TripleSubject &&
      _iri == other._iri &&
      _blankNode == other._blankNode;
}

class TripleObject<T> {
  Uri _iri;
  Literal _literal;
  Object _blankNode;

  TripleObject._();

  TripleObject.iri(this._iri);

  TripleObject.literal(this._literal);

  TripleObject.blankNode(this._blankNode);

  Uri get asIri => _iri;

  Literal get asLiteral => _literal;

  Object get asBlankNode => _blankNode;

  @override
  int get hashCode => hash3(_iri, _literal, _blankNode);

  @override
  bool operator ==(other) =>
      other is TripleObject &&
      _iri == other._iri &&
      _literal == other._literal &&
      _blankNode == other._blankNode;
}
