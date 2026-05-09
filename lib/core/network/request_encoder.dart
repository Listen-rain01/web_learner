enum RequestEncoding {
  plain,
  esdt,
  urlEncoded,
}

class AppRequestEncoder {
  const AppRequestEncoder();

  String encode(String value, {required RequestEncoding type}) {
    switch (type) {
      case RequestEncoding.plain:
        return value;
      case RequestEncoding.esdt:
        return esdt(value);
      case RequestEncoding.urlEncoded:
        return Uri.encodeQueryComponent(value);
    }
  }

  String esdt(String value) {
    final codes = value.runes.map((rune) => rune.toString()).toList();
    final joinedCodes = codes.join();
    final lengths = codes.map((code) => code.length).join(',');

    return Uri.encodeComponent('$joinedCodes^$lengths');
  }
}
