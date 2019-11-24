import 'package:string_scanner/string_scanner.dart';

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

  static const Map<String, DataType> xsdTypes = {};
}

class StringDataType implements DataType<String> {
  const StringDataType();

  @override
  String parse(String form) => form;
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

class DoubleDataType implements DataType<double> {
  const DoubleDataType();

  static final RegExp _posInf = RegExp(r'\+?Inf');
  static final RegExp _zero = RegExp(r'[+-]?0');

  @override
  double parse(String form) {
    var scnr = StringScanner(form);
    if (scnr.scan(_posInf)) {
      return double.infinity;
    } else if (scnr.scan('-Inf')) {
      return double.negativeInfinity;
    } else if (scnr.scan(_zero)) {
      return 0.0;
    } else if (scnr.scan('Nan')) {
      return double.nan;
    } else {
      return double.parse(form);
    }
  }
}

class FloatDataType extends DoubleDataType {
  const FloatDataType();
}

class DateDataType implements DataType<DateTime> {
  const DateDataType();

  /*
    These are the rules (ignore most of them):
    [56]   yearFrag ::= '-'? (([1-9] digit digit digit+)) | ('0' digit digit digit))
    [57]   monthFrag ::= ('0' [1-9]) | ('1' [0-2])
    [58]   dayFrag ::= ('0' [1-9]) | ([12] digit) | ('3' [01])
    [59]   hourFrag ::= ([01] digit) | ('2' [0-3])
    [60]   minuteFrag ::= [0-5] digit
    [61]   secondFrag ::= ([0-5] digit) ('.' digit+)?
    [62]   endOfDayFrag ::= '24:00:00' ('.' '0'+)?
    [63]   timezoneFrag ::= 'Z' | ('+' | '-') (('0' digit | '1' [0-3]) ':' minuteFrag | '14:00')
  */

  static final RegExp _int = RegExp(r'[0-9]+');

  static int _parseInt(StringScanner scnr) {
    scnr.expect(_int);
    return int.parse(scnr.lastMatch[0]);
  }

  @override
  DateTime parse(String form) {
    var scnr = StringScanner(form);
    var year = _parseInt(scnr);
    scnr.expect('-');
    var month = _parseInt(scnr);
    scnr.expect('-');
    var day = _parseInt(scnr);
    if (scnr.scan('Z')) {
      scnr.expectDone();
      return DateTime.utc(year, month, day);
    } else if (scnr.scan('+') || scnr.scan('-')) {
      // TODO: Timezone parsing
      var add = scnr.lastMatch[0] == '+';
      var hour = _parseInt(scnr);
      scnr.expect(':');
      var minute = _parseInt(scnr);
      scnr.expectDone();
      var dt = DateTime.utc(year, month, day);
      var offset = Duration(hours: hour, minutes: minute);
      if (add) {
        return dt.add(offset);
      } else {
        return dt.subtract(offset);
      }
    } else {
      scnr.expectDone();
      return DateTime(year, month, day);
    }
  }
}
