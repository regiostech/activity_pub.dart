import 'package:quiver_hashcode/hashcode.dart';
import 'literal.dart';

const BlankNode blankNode = BlankNode._();

class BlankNode {
  const BlankNode._();

  @override
  String toString() => '<blank node>';
}

/// A generalized RDF triple.
class Triple {
  TripleObject subject;
  TripleObject predicate;
  TripleObject object;

  factory Triple.fromIterable(Iterable it) {
    return Triple.from(it.elementAt(0), it.elementAt(1), it.elementAt(2));
  }

  Triple(this.subject, this.predicate, this.object);

  Triple.from(subject, predicate, object) {
    this.subject = TripleObject(subject);
    this.predicate = TripleObject(predicate);
    this.object = TripleObject(object);
  }

  @override
  int get hashCode => hash3(subject, predicate, object);

  @override
  bool operator ==(other) =>
      other is Triple &&
      subject == other.subject &&
      predicate == other.predicate &&
      object == other.object;

  @override
  String toString() => '$subject $predicate $object .';
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

  @override
  String toString() {
    if (_iri != null) {
      return '<$_iri>';
    } else if (_blankNode != null) {
      return _blankNode.toString();
    } else {
      return _literal.value.toString();
    }
  }
}
