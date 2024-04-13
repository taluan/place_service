import 'dart:convert';

import 'geocoding_result.dart';

class GeocodingResponse {
  final String? status;
  final List<GeocodingResult>? results;

  GeocodingResponse({this.status, this.results});

  factory GeocodingResponse.fromJson(Map<String, dynamic> json) {
    return GeocodingResponse(
      status: json['status'],
      results: json['results']?.map<GeocodingResult>((json) => GeocodingResult.fromJson(json))
              .toList(),
    );
  }

  static GeocodingResponse parseGeocodingResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    return GeocodingResponse.fromJson(parsed);
  }
}
