/// Number formatting helpers for the UI.
class Format {
  /// Formats a monetary value with thousands separators and 2 decimal places.
  ///
  /// Example: 15879.46 becomes "15,879.46"
  static String money(double value) {
    // Format to 2 decimal places
    String stringValue = value.toStringAsFixed(2);

    // Split into integer and decimal parts
    List<String> parts = stringValue.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '00';

    // Add thousands separators to integer part
    String formattedInteger = '';
    int length = integerPart.length;

    for (int i = 0; i < length; i++) {
      if (i > 0 && (length - i) % 3 == 0) {
        formattedInteger += ',';
      }
      formattedInteger += integerPart[i];
    }

    return '$formattedInteger.$decimalPart';
  }

  /// Formats a percentage value with 2 decimal places and a percent sign.
  ///
  /// Example: 17.07 becomes "17.07%"
  static String percent(double value) {
    return '${value.toStringAsFixed(2)}%';
  }
}
