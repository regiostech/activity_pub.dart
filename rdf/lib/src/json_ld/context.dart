import 'package:rdf/rdf.dart';
import 'uri_or.dart';

class Context {
  Uri baseIri;
  var termDefinitions = <Uri, TermDefinition>{};
  // Vocabulary vocabulary;
  UriOr<BlankNode> vocabularyMapping;
  String defaultLanguage;

  Context clone() {
    return Context()
      ..termDefinitions.addAll(termDefinitions)
      // ..vocabulary = vocabulary
      ..vocabularyMapping = vocabularyMapping?.copy()
      ..defaultLanguage = defaultLanguage;
  }
}

class Vocabulary {}

class TermDefinition {
  Uri iriMapping;
  var reverseProperty = <Uri, bool>{};
  DataType typeMapping;
  var containerMapping = {};
}
