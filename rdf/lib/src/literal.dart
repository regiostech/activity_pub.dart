import 'package:quiver_hashcode/hashcode.dart';
import 'data_type.dart';

class Literal {
  static final Uri langStringIri =
      Uri.parse('http://www.w3.org/1999/02/22-rdf-syntax-ns#langString');

  String _form;
  Uri _dataType;
  String _languageTag;
  var _value;

  Literal(this._form, this._dataType);

  Literal.languageTaggedString(this._form, String languageTag)
      : _dataType = langStringIri,
        _languageTag = languageTag.toLowerCase() {
    if (languageTag.isEmpty) {
      throw ArgumentError.value(
          languageTag, 'languageTag', 'must not be empty');
    }
  }

  String get form => _form;

  Uri get dataType => _dataType;

  String get languageTag => _languageTag;

  set form(String value) {
    _form = value;
    _value = null;
  }

  set dataType(Uri value) {
    _dataType = value;
    _value = null;
  }

  set languageTag(String value) {
    _dataType = langStringIri;
    _languageTag = value;
    _value = null;
  }

  bool get isLanguageTaggedString => _languageTag != null;

  Object get value {
    if (_value != null) {
      return _value;
    }

    if (isLanguageTaggedString) {
      return _value = MapEntry(_form, _languageTag);
    }

    var xsdName = DataType.extractXsdType(_dataType);
    var xsdType = DataType.xsdTypes[xsdName];
    if (xsdType != null) {
      try {
        return _value = xsdType.parse(_form);
      } on FormatException {
        // Otherherwise, the literal is ill-typed, just return null.
        return null;
      }
    } else {
      return null;
    }
  }

  bool isTermEqualTo(Literal other) {
    return _form == other._form &&
        _dataType == other._dataType &&
        _languageTag == other._languageTag;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(other) => other is Literal && value == other.value;
}
