import 'package:quiver_hashcode/hashcode.dart';

class Literal {
  static final Uri langStringIri =
      Uri.parse('http://www.w3.org/1999/02/22-rdf-syntax-ns#langString');

  String form;
  Uri dataType;
  String _languageTag;

  Literal(this.form, this.dataType);

  Literal.languageTaggedString(this.form, String languageTag)
      : dataType = langStringIri,
        _languageTag = languageTag.toLowerCase() {
    if (languageTag.isEmpty) {
      throw ArgumentError.value(
          languageTag, 'languageTag', 'must not be empty');
    }
  }

  bool get isLanguageTaggedString => _languageTag != null;

  String get languageTag => _languageTag;

  Object get value {
    if (isLanguageTaggedString) {
      return MapEntry(form, _languageTag);
    }
    // TODO: Data types
    else if (true) {
    } else {
      return null;
    }
  }
}
