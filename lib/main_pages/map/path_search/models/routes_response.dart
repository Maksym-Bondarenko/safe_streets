import 'edge.dart';

/// common class for safest and fastest route,
/// containing edgesList (coordinates), total length and total crime likelihood
class RouteResponse {
  final double totalLength;
  final double totalCrimeLikelihood;
  final List<Edge> edgesList;


  RouteResponse({
    required this.totalLength,
    required this.totalCrimeLikelihood,
    required this.edgesList,
  });

  factory RouteResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> edgesListJson = json['edges_list'];
    List<Edge> edgesList =
    edgesListJson.map((edgeJson) => Edge.fromJson(edgeJson)).toList();

    return RouteResponse(
      totalLength: json['total_length'],
      totalCrimeLikelihood: json['total_crime_likelihood'],
      edgesList: edgesList,
    );
  }

  double get length => totalLength;
  double get crimeLikelihood => totalCrimeLikelihood;
  List<Edge> get edges => edgesList;
}

