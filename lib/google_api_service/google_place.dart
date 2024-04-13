library google_place;

import 'package:place_service/google_api_service/search/search.dart';

import 'autocomplete/autocomplete.dart';
import 'details/details.dart';
import 'geocoding/geocoding.dart';
import 'photos/photos.dart';
import 'query_autocomplete/query_autocomplete.dart';

export 'autocomplete/autocomplete_prediction.dart';
export 'autocomplete/autocomplete_response.dart';
export 'details/details_response.dart';
export 'details/details_result.dart';
export 'models/address_component.dart';
export 'models/bounds.dart';
export 'models/close.dart';
export 'models/component.dart';
export 'models/debug_log.dart';
export 'models/geometry.dart';
export 'models/input_type.dart';
export 'models/lat_lon.dart';
export 'models/location.dart';
export 'models/locationbias.dart';
export 'models/main_text_matched_substring.dart';
export 'models/matched_substring.dart';
export 'models/northeast.dart';
export 'models/open.dart';
export 'models/opening_hours.dart';
export 'models/period.dart';
export 'models/photo.dart';
export 'models/plus_code.dart';
export 'models/rank-by.dart';
export 'models/review.dart';
export 'models/southwest.dart';
export 'models/structured_formatting.dart';
export 'models/term.dart';
export 'models/viewport.dart';
export 'search/find_place_response.dart';
export 'search/near_by_search_response.dart';
export 'search/search_candidate.dart';
export 'search/search_result.dart';
export 'search/text_search_response.dart';

/// The Places API is a service that returns information about places.
/// Places are defined within this API as establishments, geographic locations, or prominent points of interest.
class GooglePlace {
  /// [apiKEY] Your application's API key. This key identifies your application.
  final String apiKEY;

  /// [search] returns a list of places based on a user's location or search string.
  late Search search;

  /// [details] returns more detailed information about a specific place, including user reviews.
  late Details details;

  /// [photos] provides access to the millions of place-related photos stored in Google's Place database.
  late Photos photos;

  /// [autocomplete] automatically fills in the name and/or address of a place as users type.
  late Autocomplete autocomplete;

  /// [queryAutocomplete] provides a query prediction service for text-based geographic searches, returning suggested queries as users type.
  late QueryAutocomplete queryAutocomplete;

  /// [timeout] timeout for http call.
  static Duration timeout = Duration(milliseconds: 1500);

  /// Optional headers to pass on each request
  final Map<String, String> headers;

  /// Optional proxy url to web request
  /// Can be formatted as [https:// || http://]host[:<port>][/<path>][?<url-param-name>=]
  /// http proxies are supported, but are not recommended for production use.
  final String? proxyUrl;

  late Geocoding geocoding;

  GooglePlace(
    this.apiKEY, {
    this.headers = const {},
    this.proxyUrl,
  }) {
    this.search = Search(apiKEY, headers, proxyUrl);
    this.details = Details(apiKEY, headers, proxyUrl);
    this.photos = Photos(apiKEY, headers, proxyUrl);
    this.autocomplete = Autocomplete(apiKEY, headers, proxyUrl);
    this.queryAutocomplete = QueryAutocomplete(apiKEY, headers, proxyUrl);
    this.geocoding = Geocoding(apiKEY);
  }
}
