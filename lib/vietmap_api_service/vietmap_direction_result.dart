import 'package:place_service/google_api_service/utils/helper_utils.dart';
import 'package:place_service/google_api_service/utils/flinq/flinq.dart';

class VietmapDirectionResult {
  final String? license;
  final String? code;
  final String? messages;
  List<VietmapDirectionsRoute>? routes;

  VietmapDirectionResult({this.license, this.code, this.messages, this.routes});

  factory VietmapDirectionResult.fromMap(Map<String, dynamic> map) =>
      VietmapDirectionResult(
        license: map['license'] as String?,
        code: map['code'] as String?,
        messages: map['messages'] as String?,
        routes: (map['paths'] as List?)?.mapList((json) => VietmapDirectionsRoute.fromMap(json)),
      );
}

class VietmapDirectionsRoute {
  double? distance = 0;
  double? weight = 0;
  double? time = 0;
  String? points;
  String? snappedWaypoints;

  VietmapDirectionsRoute(
      {this.distance,
      this.weight,
      this.time,
      this.points,
      this.snappedWaypoints});

  factory VietmapDirectionsRoute.fromMap(Map<String, dynamic> map) =>
      VietmapDirectionsRoute(
        distance: parseDouble(map['distance']),
        weight: parseDouble(map['weight']),
        time: parseDouble(map['time']),
        points: map['points'] as String?,
        snappedWaypoints: map['snapped_waypoints'] as String?,
      );
}
