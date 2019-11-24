import 'document.dart';
import 'node_object.dart';

class Parser {
  Document parse(input) {
    if (input is Map) {
      // TODO: Differentiate this from multi-node documents?
      var node = parseNodeObject(input);
      return Document(nodes: [node]);
    } else if (input is Iterable && input.every((x) => x is Map)) {
      var objects = input.cast<Map>();
      var nodes = objects.map(parseNodeObject);
      return Document(nodes: nodes);
    } else {
      throw FormatException('A JSON-LD document must be a single node '
          'object or an array whose elements are each node objects at '
          'the top level.');
    }
  }

  NodeObject parseNodeObject(Map input) {}
}
