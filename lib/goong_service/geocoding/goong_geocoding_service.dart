
import 'dart:convert';


import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../goong_service.dart';
import '../places/goong_place_result.dart';


/// This service is used to calculate route between two points
class GoongGeocodingService {
  static const _geocodingApiUrl =
      'https://rsapi.goong.io/geocode';

  GoongGeocodingService._instance();
  static final GoongGeocodingService instance = GoongGeocodingService._instance();

  /// `callback` argument will be called when route calculations finished.
  Future<List<GoongPlaceResult>> reverseGeocoding(
    double lat,
    double lng) async {
    List<GoongPlaceResult> list = [];
    try {
      final url = '$_geocodingApiUrl?latlng=$lat,$lng&api_key=${GoongService.Goong_Api_Key}';
      final response = await http.get(Uri.parse(url));

      // debugPrint("goong direction url: $url");
      if (response.statusCode == 200) {
       Map<String, dynamic> map = json.decode(response.body);
       List<dynamic> results = map['results'] ?? [];
       for (var result in results) {
         final location = GoongPlaceResult.fromJson(result);
         if (location != null) {
           list.add(location);
           if (list.length >= 4) {
             return list;
           }
         }
       }
      } else {
        debugPrint("reverseGeocoding error: ${response.statusCode} (${response.reasonPhrase}), uri = ${response.request!.url}");
      }

    } catch(e) {
      debugPrint("reverseGeocoding error: ${e.toString()}");
    }
    return list;
  }

  Future<GoongPlaceResult?> forwardGeocoding(String address) async {
    try {
      final url = Uri.encodeFull('$_geocodingApiUrl?address=$address&api_key=${GoongService.Goong_Api_Key}');
      final response = await http.get(Uri.parse(url));

      debugPrint("forwardGeocoding url: $url");
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        List<dynamic> results = map['results'] ?? [];
        if (results.isNotEmpty) {
          return GoongPlaceResult.fromJson(results.firstOrNull);
        }
      } else {
        debugPrint("forwardGeocoding error: ${response.statusCode} (${response.reasonPhrase}), uri = ${response.request!.url}");
      }

    } catch(e) {
      debugPrint("forwardGeocoding error: ${e.toString()}");
    }
    return null;
  }

  Future<GoongPlaceResult?> getPlaceDetail(String place_id) async {
    try {
      final url = Uri.encodeFull('$_geocodingApiUrl?place_id=$place_id&api_key=${GoongService.Goong_Api_Key}');
      final response = await http.get(Uri.parse(url));

      debugPrint("getPlaceDetail url: $url");
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        List<dynamic> results = map['results'] ?? [];
        if (results.isNotEmpty) {
          return GoongPlaceResult.fromJson(results.firstOrNull);
        }
      } else {
        debugPrint("getPlaceDetail error: ${response.statusCode} (${response.reasonPhrase}), uri = ${response.request!.url}");
      }

    } catch(e) {
      debugPrint("getPlaceDetail error: ${e.toString()}");
    }
    return null;
  }
}
