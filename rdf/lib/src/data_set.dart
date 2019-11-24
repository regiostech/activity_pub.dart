import 'graph.dart';

class DataSet {
  Graph defaultGraph;
  var namedGraphs = <Uri, Graph>{};

  DataSet({this.defaultGraph, Map<Uri, Graph> namedGraphs = const {}}) {
    this.namedGraphs.addAll(namedGraphs ?? {});
  }
}
