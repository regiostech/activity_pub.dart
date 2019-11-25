import 'package:rdf/rdf.dart';
import 'uri_or.dart';

class Context {
  Uri baseIri;
  var termDefinitions = <String, TermDefinition>{};
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
  // Uri iriMapping;
  Object iriMapping;
  // var reverseProperty = <Uri, bool>{};
  bool reverseProperty = false;
  // Uri typeMapping;
  Object typeMapping;
  String containerMapping;
  String languageMapping;
}
