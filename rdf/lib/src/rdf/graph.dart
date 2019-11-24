import 'triple.dart';

class Graph {
  final Set<Triple> triples = Set();

  Graph();

  Graph.from(Iterable<Triple> triples) {
    this.triples.addAll(triples);
  }
}
