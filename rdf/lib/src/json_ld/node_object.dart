import 'context_definition.dart';
import 'list_or.dart';
import 'uri_or.dart';

// https://www.w3.org/TR/json-ld/#dfn-node-object
class NodeObject {
  ListOr<UriOr<ContextDefinition>> context;
  Uri id;
  ListOr<NodeObject> graph;
  ListOr<UriOr<String>> type;
  Map<String, ListOr> reverse;
  String index;
  Map<String, dynamic> otherValues;
  NodeObject({this.context, this.id});
}
