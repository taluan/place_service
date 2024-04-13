

import '../../google_api_service/directions/directions.dart';
import '../../google_api_service/directions/directions.response.dart';
import '../../google_api_service/utils/flinq/flinq.dart';

class GoongDirectionsResult {
  const GoongDirectionsResult({
    this.routes,
    this.geocodedWaypoints,
    this.errorMessage,
    this.availableTravelModes,
  });

  factory GoongDirectionsResult.fromMap(Map<String, dynamic> map) =>
      GoongDirectionsResult(
        routes: (map['routes'] as List?)
            ?.mapList((_) => GoongDirectionsRoute.fromMap(_)),
        geocodedWaypoints:
        (map[''] as List?)?.mapList((_) => GeocodedWaypoint.fromMap(_)),
        errorMessage: map['error_message'] as String?,
        availableTravelModes: (map['available_travel_modes'] as List?)
            ?.mapList((_) => TravelMode(_)),
      );

  /// When the Directions API returns results, it places them within a
  /// (JSON) routes array. Even if the service returns no results (such
  /// as if the origin and/or destination doesn't exist) it still
  /// returns an empty routes array. (XML responses consist of zero or
  /// more <route> elements.)
  ///
  /// Each element of the routes array contains a single result from
  /// the specified origin and destination. This route may consist of
  /// one or more legs depending on whether any waypoints were specified.
  /// As well, the route also contains copyright and warning information
  /// which must be displayed to the user in addition to the routing
  /// information.
  final List<GoongDirectionsRoute>? routes;

  /// Details about the geocoding of every waypoint, as well as origin
  /// and destination, can be found in the (JSON) geocoded_waypoints
  /// array. These can be used to infer why the service would return
  /// unexpected or no routes.
  ///
  /// Elements in the geocoded_waypoints array correspond, by their
  /// zero-based position, to the origin, the waypoints in the order
  /// they are specified, and the destination.
  final List<GeocodedWaypoint>? geocodedWaypoints;


  /// When the status code is other than OK, there may be an additional
  /// `errorMessage` field within the Directions response object. This
  /// field contains more detailed information about the reasons behind
  /// the given status code.
  final String? errorMessage;

  /// Contains an array of available travel modes. This field is returned
  /// when a request specifies a travel mode and gets no results. The array
  /// contains the available travel modes in the countries of the given set
  /// of waypoints. This field is not returned if one or more of the
  /// waypoints are via: waypoints. See details below.
  final List<TravelMode>? availableTravelModes;
}

class GoongDirectionsRoute {
  const GoongDirectionsRoute({
    this.bounds,
    this.copyrights,
    this.legs,
    this.overviewPolyline,
    this.summary,
    this.warnings,
    this.waypointOrder,
    this.fare,
  });

  factory GoongDirectionsRoute.fromMap(Map<String, dynamic> map) => GoongDirectionsRoute(
    bounds: null,
    copyrights: map['copyrights'] as String?,
    legs: (map['legs'] as List?)?.mapList((_) => Leg.fromMap(_)),
    overviewPolyline: map['overview_polyline'] != null
        ? OverviewPolyline.fromMap(map['overview_polyline'])
        : null,
    summary: map['summary'] as String?,
    warnings: (map['warnings'] as List?)?.mapList((_) => _ as String?),
    waypointOrder: (map['waypoint_order'] as List?)
        ?.mapList((_) => num.tryParse(_.toString())),
    fare: map['fare'] != null ? Fare.fromMap(map['fare']) : null,
  );

  /// Contains the viewport bounding box of the [overviewPolyline].
  final GeoCoordBounds? bounds;

  /// Contains the copyrights text to be displayed for this route.
  /// You must handle and display this information yourself.
  final String? copyrights;

  /// Contains an array which contains information about a
  /// leg of the route, between two locations within the given route.
  /// A separate leg will be present for each waypoint or destination
  /// specified. (A route with no waypoints will contain exactly one
  /// leg within the legs array.) Each leg consists of a series of
  /// steps. (See [Leg].)
  final List<Leg>? legs;

  /// Contains a single points object that holds an
  /// [encoded polyline][enc_polyline] representation of the route.
  /// This polyline is an approximate (smoothed) path of the resulting
  /// directions.
  ///
  /// [enc_polyline]: https://developers.google.com/maps/documentation/utilities/polylinealgorithm
  final OverviewPolyline? overviewPolyline;

  /// Contains a short textual description for the route, suitable for
  /// naming and disambiguating the route from alternatives.
  final String? summary;

  /// Contains an array of warnings to be displayed when showing these
  /// directions. You must handle and display these warnings yourself.
  final List<String?>? warnings;

  /// Contains an array indicating the order of any waypoints in the
  /// calculated route. This waypoints may be reordered if the request
  /// was passed `optimize:true` within its waypoints parameter.
  final List<num?>? waypointOrder;

  /// Contains the total fare (that is, the total
  /// ticket costs) on this route. This property is only returned for
  /// transit requests and only for routes where fare information is
  /// available for all transit legs. The information includes:
  ///   * `currency`: An [ISO 4217 currency code][iso4217] indicating the
  /// currency that the amount is expressed in.
  ///   * `value`: The total fare amount, in the currency specified above.
  ///   * `text`: The total fare amount, formatted in the requested language.
  ///
  /// [iso4217]: https://en.wikipedia.org/wiki/ISO_4217
  final Fare? fare;
}