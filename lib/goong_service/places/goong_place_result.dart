class GoongPlaceResult {
  double? latitude;
  double? longitude;
  String? address;
  String? city;
  String? province;
  String? name;

  GoongPlaceResult(
      {this.latitude,
      this.longitude,
      this.address,
      this.city,
      this.province,
      this.name});

  static GoongPlaceResult? fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      Map<String, dynamic>? geometry = json['geometry'];
      Map<String, dynamic>? location = geometry?['location'];
      String address = (json['formatted_address'] ?? "").replaceAll(" 70000", "").trim();
      if (location != null && address.isNotEmpty) {
        List<String> arrAdd = address.split(", ");
        String city = "";
        String province = "";
        if (arrAdd.length > 2) {
          city = arrAdd[arrAdd.length-2];
          province = arrAdd[arrAdd.length-1];
        }

        return GoongPlaceResult(
            latitude: location['lat']?.toDouble(),
            longitude: location['lng']?.toDouble(),
            address: address,
            city: city,
            province: province, name: arrAdd[0]);
      }
    }
    return null;
  }

}