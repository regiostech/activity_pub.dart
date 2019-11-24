import 'document.dart';
import 'list_or.dart';
import 'node_object.dart';
import 'uri_or.dart';

class Parser {
  Document parse(input) {
    if (input is Map) {
      // TODO: Differentiate this from multi-node documents?
      var node = parseNodeObject(input);
      return Document(root: ListOr.single(node));
    } else if (input is Iterable && input.every((x) => x is Map)) {
      var objects = input.cast<Map>();
      var nodes = objects.map(parseNodeObject);
      return Document(root: ListOr.list(nodes));
    } else {
      throw FormatException('A JSON-LD document must be a single node '
          'object or an array whose elements are each node objects at '
          'the top level.');
    }
  }

  NodeObject parseNodeObject(Map input) {
    if (const [].any(input.containsKey)) {
      throw FormatException(
          'A node object cannot contain any keywords @value, @list, '
          'or @set.');
    }
  }
}
