
import 'dart:convert';


import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../google_api_service/models/location_model.dart';
import '../../google_api_service/utils/helper_utils.dart';
import '../goong_service.dart';


/// This service is used to calculate route between two points
class GoongGeocodingService {
  static const _geocodingApiUrl =
      'https://rsapi.goong.io/geocode';

  GoongGeocodingService._instance();
  static final GoongGeocodingService instance = GoongGeocodingService._instance();

  /// `callback` argument will be called when route calculations finished.
  Future<List<LocationModel>> reverseGeocoding(
    double lat,
    double lng) async {
    List<LocationModel> list = [];
    try {
      final url = '$_geocodingApiUrl?latlng=$lat,$lng&api_key=${GoongService.Goong_Api_Key}';
      final response = await http.get(Uri.parse(url));

      // debugPrint("goong direction url: $url");
      if (response.statusCode == 200) {
       Map<String, dynamic> map = json.decode(response.body);
       List<dynamic> results = map['results'] ?? [];
       for (var result in results) {
         Map<String, dynamic>? geometry = result['geometry'];
         Map<String, dynamic>? location = geometry?['location'];
         String address = (result['formatted_address'] ?? "").replaceAll(" 70000", "").trim();
         if (location != null && address.isNotEmpty) {
           List<String> arrAdd = address.split(", ");
           String city = "";
           String province = "";
           if (arrAdd.length > 2) {
             city = arrAdd[arrAdd.length-2];
             province = arrAdd[arrAdd.length-1];
           }

           final locationModel = LocationModel(
               latitude: parseDouble(location['lat']),
               longitude: parseDouble(location['lng']),
               address: address,
               city: city,
               province: province, name: arrAdd[0]);
           debugPrint(locationModel.toString());
           list.add(locationModel);
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

  Future<LocationModel?> forwardGeocoding(String address) async {
    try {
      final url = Uri.encodeFull('$_geocodingApiUrl?address=$address&api_key=${GoongService.Goong_Api_Key}');
      final response = await http.get(Uri.parse(url));

      debugPrint("forwardGeocoding url: $url");
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        List<dynamic> results = map['results'] ?? [];
        if (results.isNotEmpty) {
          Map<String, dynamic>? geometry = results.first['geometry'];
          Map<String, dynamic>? location = geometry?['location'];
          String address = (results.first['formatted_address'] ?? "").replaceAll(" 70000", "").trim();
          if (location != null && address.isNotEmpty) {
            List<String> arrAdd = address.split(", ");
            String city = "";
            String province = "";
            if (arrAdd.length > 2) {
              city = arrAdd[arrAdd.length-2];
              province = arrAdd[arrAdd.length-1];
            }

            return LocationModel(
                latitude: parseDouble(location['lat']),
                longitude: parseDouble(location['lng']),
                address: address,
                city: city,
                province: province, name: arrAdd[0]);
          }
        }
      } else {
        debugPrint("forwardGeocoding error: ${response.statusCode} (${response.reasonPhrase}), uri = ${response.request!.url}");
      }

    } catch(e) {
      debugPrint("forwardGeocoding error: ${e.toString()}");
    }
    return null;
  }

  Future<LocationModel?> getPlaceDetail(String place_id) async {
    try {
      final url = Uri.encodeFull('$_geocodingApiUrl?place_id=$place_id&api_key=${GoongService.Goong_Api_Key}');
      final response = await http.get(Uri.parse(url));

      debugPrint("getPlaceDetail url: $url");
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        List<dynamic> results = map['results'] ?? [];
        if (results.isNotEmpty) {
          Map<String, dynamic>? geometry = results.first['geometry'];
          Map<String, dynamic>? location = geometry?['location'];
          String address = (results.first['formatted_address'] ?? "").replaceAll(" 70000", "").trim();
          if (location != null && address.isNotEmpty) {
            List<String> arrAdd = address.split(", ");
            String city = "";
            String province = "";
            if (arrAdd.length > 2) {
              city = arrAdd[arrAdd.length-2];
              province = arrAdd[arrAdd.length-1];
            }

            return LocationModel(
                latitude: parseDouble(location['lat']),
                longitude: parseDouble(location['lng']),
                address: address,
                city: city,
                province: province, name: arrAdd[0]);
          }
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
