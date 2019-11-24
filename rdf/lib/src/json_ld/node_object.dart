import 'context_definition.dart';
import 'list_or.dart';
import 'uri_or.dart';

class NodeObject {
  ListOr<UriOr<ContextDefinition>> context;
  Uri id;
  List<NodeObject> graphs;
  NodeObject({this.context, this.id});
}
