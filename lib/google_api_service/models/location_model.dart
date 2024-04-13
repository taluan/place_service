import 'dart:convert';

import '../utils/helper_utils.dart';

class LocationModel {
  double latitude = 0.0;
  double longitude = 0.0;
  String address = "";
  String city = "";
  String province = "";
  String ghiChu = "";
  String name = "";
  String hoTen = "";
  String soDienThoai = "";
  LocationModel(
      {required this.latitude,
      required this.longitude,
      required this.address,
      this.city = "",
      this.province = "",
      this.ghiChu = "",
      this.name = ""}) {
    if (name.isEmpty && address.isNotEmpty) {
      name = address.split(",").first;
    }
  }

  LocationModel.fromJson(Map<String, dynamic> json) {
    latitude = parseDouble(json["Latitude"]);
    longitude = parseDouble(json["Longitude"]);
    address = json["Address"] ?? "";
    city = json["City"] ?? "";
    province = json["Province"] ?? "";
    ghiChu = json["GhiChu"] ?? json["GhiChuTaiXe"] ?? "";
    name = json["Name"] ?? "";
    hoTen = json["HoTen"] ?? "";
    soDienThoai = json["SoDienThoai"] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Latitude'] = latitude.toString();
    data['Longitude'] = longitude.toString();
    data['Address'] = address;
    data['City'] = city;
    data['Province'] = province;
    data['GhiChu'] = ghiChu;
    data['Name'] = name;
    data['HoTen'] = hoTen;
    data['SoDienThoai'] = soDienThoai;
    return data;
  }

  String? get toJsonString {
    return jsonEncode(toJson());
  }

  static LocationModel? fromString(String? stringJson) {
    if (stringJson != null) {
      Map<String, dynamic>? json = jsonDecode(stringJson);
      if (json != null) {
        return LocationModel.fromJson(json);
      }
    }
    return null;
  }

  String toString() {
    return "$name - $address - $latitude,$longitude}";
  }
  String toLngLatString() {
    return "$longitude;$latitude";
  }
}
