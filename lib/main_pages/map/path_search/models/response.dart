import 'package:safe_streets/main_pages/map/path_search/models/routes_response.dart';

/// class-wrapper for safest and fastest routes
class Response {
  final RouteResponse safestRouteResponse;
  final RouteResponse shortestRouteResponse;

  Response(
      {required this.safestRouteResponse, required this.shortestRouteResponse}
  );

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      safestRouteResponse: RouteResponse.fromJson(json['safest_route']),
      shortestRouteResponse:
      RouteResponse.fromJson(json['shortest_route']),
    );
  }

  RouteResponse get safestRoute => safestRouteResponse;
  RouteResponse get shortestRoute => shortestRouteResponse;
}