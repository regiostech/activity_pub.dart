import 'package:quiver_hashcode/hashcode.dart';
import 'literal.dart';

const BlankNode blankNode = BlankNode._();

class BlankNode {
  const BlankNode._();
}

class Triple {
  TripleSubject _subject;
  Uri _predicate;
  TripleObject _object;

  factory Triple.fromIterable(Iterable it) {
    return Triple(it.elementAt(0), it.elementAt(1), it.elementAt(2));
  }

  Triple(subject, predicate, object) {
    _subject = TripleSubject(subject);
    _object = TripleObject(object);
    if (predicate is Uri) {
      _predicate = predicate;
    } else if (predicate is String) {
      _predicate = Uri.parse(predicate);
    } else {
      throw ArgumentError.value(
          predicate, 'predicate', 'must be a Uri or String');
    }
  }

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
  BlankNode _blankNode;

  factory TripleSubject(obj) {
    if (obj is Uri) {
      return TripleSubject.iri(obj);
    } else if (obj is BlankNode) {
      return TripleSubject.blankNode(obj);
    } else {
      throw ArgumentError.value(obj, 'subject', 'must be Uri or BlankNode');
    }
  }

  Uri get asIri => _iri;

  BlankNode get asBlankNode => _blankNode;

  TripleSubject.iri(this._iri);

  TripleSubject.blankNode(this._blankNode);

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
  BlankNode _blankNode;

  factory TripleObject(obj) {
    if (obj is Uri) {
      return TripleObject.iri(obj);
    } else if (obj is Literal) {
      return TripleObject.literal(obj);
    } else if (obj is BlankNode) {
      return TripleObject.blankNode(obj);
    } else {
      throw ArgumentError.value(
          obj, 'subject', 'must be Uri, Literal, or BlankNode');
    }
  }

  TripleObject._();

  TripleObject.iri(this._iri);

  TripleObject.literal(this._literal);

  TripleObject.blankNode(this._blankNode);

  Uri get asIri => _iri;

  Literal get asLiteral => _literal;

  BlankNode get asBlankNode => _blankNode;

  @override
  int get hashCode => hash3(_iri, _literal, _blankNode);

  @override
  bool operator ==(other) =>
      other is TripleObject &&
      _iri == other._iri &&
      _literal == other._literal &&
      _blankNode == other._blankNode;
}
