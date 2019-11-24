import 'node_object.dart';

class Document {
  var nodes = <NodeObject>[];

  Document({Iterable<NodeObject> nodes}) {
    this.nodes.addAll(nodes ?? []);
  }
}
