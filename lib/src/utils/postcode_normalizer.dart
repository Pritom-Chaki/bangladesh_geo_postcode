/// Maps Bangla digits (০–৯) to ASCII digits (0–9).
const _bnToEnDigits = <String, String>{
  '০': '0',
  '১': '1',
  '২': '2',
  '৩': '3',
  '৪': '4',
  '৫': '5',
  '৬': '6',
  '৭': '7',
  '৮': '8',
  '৯': '9',
};

/// Normalises a postcode string so it can be used as a map key.
///
/// * Converts Bangla digits to English digits.
/// * Trims leading/trailing whitespace.
/// * Removes dashes.
String normalizePostcode(String raw) {
  final buffer = StringBuffer();
  for (final char in raw.trim().replaceAll('-', '').runes) {
    final ch = String.fromCharCode(char);
    buffer.write(_bnToEnDigits[ch] ?? ch);
  }
  return buffer.toString();
}
