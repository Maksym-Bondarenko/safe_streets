// class contains information about single path-entity with additional information
class Edge {
  final dynamic osmid;
  final double length;
  final double predNumCrimes;
  final double predCrimeLikelihood;
  final List<List<double>> geometry;

  Edge({
    required this.osmid,
    required this.length,
    required this.predNumCrimes,
    required this.predCrimeLikelihood,
    required this.geometry,
  });

  factory Edge.fromJson(Map<String, dynamic> json) {
    List<dynamic> geometryJson = json['geometry'];
    List<List<double>> geometry =
    geometryJson.map((point) => List<double>.from(point)).toList();

    return Edge(
      osmid: json['osmid'],
      length: json['length'],
      predNumCrimes: json['pred_num_crimes'],
      predCrimeLikelihood: json['pred_crime_likelihood'],
      geometry: geometry,
    );
  }

  dynamic get getOsmid => osmid;
  double get getLength => length;
  double get getPredNumCrimes => predNumCrimes;
  double get getPredCrimeLikelihood => predCrimeLikelihood;
  List<List<double>> get getGeometry => geometry;
}