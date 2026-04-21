import 'dart:convert';

import 'package:place_service/google_api_service/utils/helper_utils.dart';
import 'package:place_service/place_service.dart';
import 'package:http/http.dart' as http;

import 'vietmap_direction_result.dart';

class VietmapService {
  static const _apiUrl = 'https://maps.vietmap.vn/api';
  static late String apiKey;

  VietmapService._instance();
  static final VietmapService instance = VietmapService._instance();

  Future<List<AutocompletePrediction>?> autoComplete(
      String input, {
        LatLon? location,
        int? radius
      }) async {
    try {
      List<String> queryParams = ["text=$input"];
      if (location != null) {
        queryParams.add("circle_center=${location.latitude},${location.longitude}");
      }
      if (radius != null) {
        queryParams.add("circle_radius=$radius");
      }
      //&layers=BUILDING
      final url = Uri.encodeFull('$_apiUrl/autocomplete/v3?${queryParams.join("&")}&apikey=$apiKey');
      final response = await http.get(Uri.parse(url));

      // debugPrint("vietmap autoComplete url: $url}");
      if (response.statusCode == 200) {
        final jsonArray = json.decode(response.body);
        if (jsonArray is List<dynamic>) {
          return jsonArray.map((v) => AutocompletePrediction(
            description: v['display'] as String?,
            distanceMeters: parseInt(v['distance']),
            id: v['ref_id'] as String?,
            placeId: v['ref_id'] as String?,
            structuredFormatting: StructuredFormatting(mainText: v['name'] as String?, secondaryText: v['address'] as String?),
          )).toList();
        }
      } else {
        // debugPrint("vietmap autoComplete error: ${response.statusCode} (${response.reasonPhrase}), uri = ${response.request!.url}");
      }

    } catch(e) {
      // debugPrint("vietmap autoComplete error: ${e.toString()}");
      return null;
    }
    return null;
  }


  Future<GoongPlaceResult?> getPlaceDetail(String place_id) async {
    try {
      final url = Uri.encodeFull('$_apiUrl/place/v3?refid=$place_id&apikey=$apiKey');
      final response = await http.get(Uri.parse(url));

      // debugPrint("vietmap getPlaceDetail url: $url\nresponse: ${response.body}");
      if (response.statusCode == 200) {
        Map<String, dynamic>? result = json.decode(response.body);
        if (result != null) {
          String name = result['name'] ?? "";
          if (name.isEmpty) {
            name = result['address'] ?? "";
          }
          final address = result['display'] ?? "";
          List<String> arrAdd = address.split(", ");
          String province = "";
          if (arrAdd.length > 2) {
            province = arrAdd[arrAdd.length-1];
          }
          return GoongPlaceResult(
            address: address,
            name: name,
            city: result['city'] ?? "",
            province: province,
            latitude: parseDouble(result['lat']),
            longitude: parseDouble(result['lng']),
          );
        }
      } else {
        // debugPrint("vietmap getPlaceDetail error: ${response.statusCode} (${response.reasonPhrase}), uri = ${response.request!.url}");
      }

    } catch(e) {
      // debugPrint("vietmap getPlaceDetail error: ${e.toString()}");
    }
    return null;
  }


  Future<List<GoongPlaceResult>> reverseGeocoding(
      double lat,
      double lng) async {
    List<GoongPlaceResult> list = [];
    try {
      final url = '$_apiUrl/reverse/v3?lng=$lng&lat=$lat&apikey=$apiKey';
      final response = await http.get(Uri.parse(url));

      // debugPrint("goong direction url: $url");
      if (response.statusCode == 200) {
        List<dynamic> results = json.decode(response.body);
        for (var result in results) {
          String name = result['name'] ?? "";
          if (name.isEmpty) {
            name = result['address'] ?? "";
          }
          final address = result['display'] ?? "";
          List<String> arrAdd = address.split(", ");
          String province = "";
          if (arrAdd.length > 2) {
            province = arrAdd[arrAdd.length-1];
          }
          final location =  GoongPlaceResult(
            address: address,
            name: name,
            city: result['city'] ?? "",
            province: province,
            latitude: parseDouble(result['lat']),
            longitude: parseDouble(result['lng']),
          );
          list.add(location);
          if (list.length >= 4) {
            return list;
          }
        }
      } else {
        // debugPrint("reverseGeocoding error: ${response.statusCode} (${response.reasonPhrase}), uri = ${response.request!.url}");
      }

    } catch(e) {
      // debugPrint("reverseGeocoding error: ${e.toString()}");
    }
    return list;
  }

  /// Calculates route between two points.
  ///
  /// `request` argument contains origin and destination points
  /// and also settings for route calculation.
  ///
  /// `callback` argument will be called when route calculations finished.
  Future<VietmapDirectionResult?> route({
    required String origin,
    required String destination,
    String? vehicle = 'motorcycle'
  }) async {
    if (vehicle == 'bike') {
      vehicle = 'motorcycle';
    }
    try {
      final url = '$_apiUrl/route?api-version=1.1&apikey=$apiKey&point=$origin&point=$destination&vehicle=${vehicle ?? 'motorcycle'}';
      final response = await http.get(Uri.parse(url));

      // debugPrint("vietmap direction url: $url\nresponse: ${response.body}");
      if (response.statusCode == 200) {
        // debugPrint('request goong direction error: ${'${response.statusCode} (${response.reasonPhrase}), uri = ${response.request!.url}'}');
        final result = VietmapDirectionResult.fromMap(json.decode(response.body));
        if (result.code == 'OK' && result.routes?.isNotEmpty == true) {
          return result;
        }
      }
    } catch(e) {
      rethrow;
    }
    return null;
  }


}