
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:place_service/goong_service/goong_service.dart';

import '../../google_api_service/autocomplete/autocomplete_response.dart';
import '../../google_api_service/models/lat_lon.dart';
import 'goong_place_result.dart';
class GoongPlacesService {

  static const _placesApiUrl =
      'https://rsapi.goong.io/Place';

  GoongPlacesService._instance();
  static final GoongPlacesService instance = GoongPlacesService._instance();

  Future<AutocompleteResponse?> autoComplete(
      String input, {
        LatLon? location,
        int? radius,
        String? sessionToken,
      }) async {
    try {
      List<String> queryParams = ["input=$input"];
      if (location != null) {
        queryParams.add("location=${location.latitude},${location.longitude}");
      }
      if (radius != null) {
        queryParams.add("radius=$radius");
      }
      if (sessionToken != null) {
        queryParams.add("sessiontoken=$sessionToken");
      }
      final Goong_Api_Key = GoongService.Goong_Api_Key;
      final url = Uri.encodeFull('$_placesApiUrl/AutoComplete?${queryParams.join("&")}&api_key=$Goong_Api_Key');
      final response = await http.get(Uri.parse(url));

      // debugPrint("autoComplete url: $url");
      if (response.statusCode == 200) {
        return AutocompleteResponse.fromJson(json.decode(response.body));
      } else {
        debugPrint("autoComplete error: ${response.statusCode} (${response.reasonPhrase}), uri = ${response.request!.url}");
      }

    } catch(e) {
      debugPrint("autoComplete error: ${e.toString()}");
    }
    return null;
  }

  Future<GoongPlaceResult?> getPlaceDetail(String place_id, {String? sessiontoken}) async {
    try {
      final Goong_Api_Key = GoongService.Goong_Api_Key;
      final url = Uri.encodeFull('$_placesApiUrl/Detail?place_id=$place_id&sessiontoken=$sessiontoken&api_key=$Goong_Api_Key');
      final response = await http.get(Uri.parse(url));

      // debugPrint("getPlaceDetail url: $url");
      if (response.statusCode == 200) {
        Map<String, dynamic>? result = json.decode(response.body)['result'];
        return GoongPlaceResult.fromJson(result);
      } else {
        debugPrint("getPlaceDetail error: ${response.statusCode} (${response.reasonPhrase}), uri = ${response.request!.url}");
      }

    } catch(e) {
      debugPrint("getPlaceDetail error: ${e.toString()}");
    }
    return null;
  }
}