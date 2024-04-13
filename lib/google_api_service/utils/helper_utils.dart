
int parseInt(dynamic value) {
  if (value is int) {
    return value;
  } else if (value == null) {
    return 0;
  } else {
    return num.tryParse(value.toString())?.toInt() ?? 0;
  }
}

double parseDouble(dynamic value, {bool removeFormat = false}) {
  if (value is double) {
    return value;
  } else if (value == null) {
    return 0.0;
  } else {
    if (removeFormat) {
      return num.tryParse(value
          .toString()
          .replaceAll(".", "")
          .replaceAll(",", ".")
          .trim())
          ?.toDouble() ??
          0.0;
    } else {
      return num.tryParse(value.toString().replaceAll(",", ".").trim())
          ?.toDouble() ??
          0.0;
    }
  }
}

String parseString(dynamic value) {
  if (value is String) {
    return value;
  } else if (value == null) {
    return "";
  } else {
    return value.toString();
  }
}
