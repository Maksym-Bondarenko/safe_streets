class SafestRouteResponse {
  final double totalCrimeLikelihood;
  final double totalLength;
  final List<Edge> edgesList;

  SafestRouteResponse({
    required this.totalCrimeLikelihood,
    required this.totalLength,
    required this.edgesList,
  });

  factory SafestRouteResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> edgesData = json['edges_list'] ?? [];
    final List<Edge> edgesList = edgesData.map((edgeData) {
      return Edge.fromJson(edgeData);
    }).toList();

    return SafestRouteResponse(
      totalCrimeLikelihood: json['total_crime_likelihood'] ?? 0.0,
      totalLength: json['total_length'] ?? 0.0,
      edgesList: edgesList,
    );
  }
}

class Edge {
  final dynamic osmid;
  final double length;
  final double predNumCrimes;
  final double predCrimeLikelihood;
  final dynamic highway;
  final List<List<double>> geometry;
  final dynamic name;
  final dynamic ref;
  final dynamic service;
  final dynamic access;
  final bool tunnel;
  final bool bridge;
  final bool steps;

  Edge({
    required this.osmid,
    required this.length,
    required this.predNumCrimes,
    required this.predCrimeLikelihood,
    required this.highway,
    required this.geometry,
    required this.name,
    required this.ref,
    required this.service,
    required this.access,
    this.tunnel = true,
    this.bridge = true,
    this.steps = true,
  });

  factory Edge.fromJson(Map<String, dynamic> json) {
    final List<dynamic> geometryData = json['geometry'] ?? [];
    final List<List<double>> geometry = geometryData.map((pointData) {
      return List<double>.from(pointData.map((value) => value.toDouble()));
    }).toList();

    return Edge(
      osmid: json['osmid'],
      length: json['length'] ?? 0.0,
      predNumCrimes: json['pred_num_crimes'] ?? 0.0,
      predCrimeLikelihood: json['pred_crime_likelihood'] ?? 0.0,
      highway: json['highway'],
      geometry: geometry,
      name: json['name'],
      ref: json['ref'],
      service: json['service'],
      access: json['access'],
      tunnel: json['tunnel'] ?? true,
      bridge: json['bridge'] ?? true,
      steps: json['steps'] ?? true,
    );
  }
}
