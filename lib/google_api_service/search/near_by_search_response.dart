import 'dart:convert';

import '../models/debug_log.dart';
import '../search/search_result.dart';

/// The Near By Search response contains html Attributions and search results and status
class NearBySearchResponse {
  final String? status;
  final List<String>? htmlAttributions;
  final String? nextPageToken;
  final DebugLog? debugLog;
  final List<SearchResult>? results;

  NearBySearchResponse({
    this.status,
    this.htmlAttributions,
    this.nextPageToken,
    this.debugLog,
    this.results,
  });

  factory NearBySearchResponse.fromJson(Map<String, dynamic> json) {
    return NearBySearchResponse(
      status: json['status'],
      htmlAttributions: json['html_attributions'] != null
          ? (json['html_attributions'] as List<dynamic>).cast<String>()
          : null,
      nextPageToken: json['next_page_token'],
      debugLog: json['debug_log'] != null
          ? DebugLog.fromJson(json['debug_log'])
          : null,
      results: json['results']?.map<SearchResult>((json) => SearchResult.fromJson(json))
              .toList(),
    );
  }

  static NearBySearchResponse parseNearBySearchResult(String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    return NearBySearchResponse.fromJson(parsed);
  }
}
