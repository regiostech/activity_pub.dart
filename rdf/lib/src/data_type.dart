abstract class DataType<T> {
  T parse(String form);

  static final Uri xmlSchemaIri = Uri.parse('http://www.w3.org/2001/XMLSchema');

  static String extractXsdType(Uri dataType) {
    // i.e. http://www.w3.org/2001/XMLSchema#xxx -> xsd:xxx
    if (dataType.hasFragment) {
      if (dataType.removeFragment() == xmlSchemaIri) {
        return dataType.fragment;
      }
    }
    return null;
  }

  static final Map<String, DataType> xsdTypes = {};
}

class StringDataType implements DataType<String> {
  const StringDataType();
}

class BooleanDataType implements DataType<bool> {
  const BooleanDataType();

  @override
  bool parse(String form) {
    if (form == 'true' || form == '1') {
      return true;
    } else if (form == 'false' || form == '0') {
      return false;
    } else {
      throw FormatException(
          'Invalid boolean value "$form"; must be in lexical space {“true”, “false”, “1”, “0”}.');
    }
  }
}

class DecimalDataType implements DataType<double> {
  const DecimalDataType();

  @override
  double parse(String form) => double.parse(form);
}

class IntegerDataType implements DataType<int> {
  const IntegerDataType();

  @override
  int parse(String form) => int.parse(form);
}
