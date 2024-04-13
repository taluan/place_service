
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../goong_service.dart';
import 'goong_directions_result.dart';


/// This service is used to calculate route between two points
class GoongDirectionsService {
  static const _directionApiUrl =
      'https://rsapi.goong.io/Direction';

  GoongDirectionsService._instance();
  static final GoongDirectionsService instance = GoongDirectionsService._instance();

  /// Calculates route between two points.
  ///
  /// `request` argument contains origin and destination points
  /// and also settings for route calculation.
  ///
  /// `callback` argument will be called when route calculations finished.
  Future<void> route({
    required String origin,
    required String destination,
    String? vehicle,
    required void Function(GoongDirectionsResult?) callback
  }) async {
    try {
      final url = '$_directionApiUrl?origin=${_convertLocation(origin)}&destination=${_convertLocation(destination)}&vehicle=${vehicle ?? 'bike'}&api_key=${GoongService.Goong_Api_Key}';
      final response = await http.get(Uri.parse(url));

      // debugPrint("goong direction url: $url");
      if (response.statusCode != 200) {
        // debugPrint('request goong direction error: ${'${response.statusCode} (${response.reasonPhrase}), uri = ${response.request!.url}'}');
        callback(null);
      } else {
        final result = GoongDirectionsResult.fromMap(json.decode(response.body));
        callback(result);
      }
    } catch(e) {
      callback(null);
    }
  }

  String _convertLocation(String location) {
    location = location.replaceAll(', ', ',');
    return location
        .split(' ')
        .where((dynamic _) => _.trim().isNotEmpty == true)
        .join('+');
  }
}
