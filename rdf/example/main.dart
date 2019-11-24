import 'package:rdf/rdf.dart';

main() {
  var triple = Triple.from(
      Uri.parse('http://example.org/person/Mark_Twain'),
      Uri.parse('http://example.org/relation/author'),
      Uri.parse('http://example.org/books/Huckleberry_Finn'));
  print(triple);
}
