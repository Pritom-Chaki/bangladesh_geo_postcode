// ignore_for_file: avoid_print
/// Converts locations.json → assets/locations.pb (protobuf binary).
///
/// Usage:
///   dart run tool/convert_json_to_protobuf.dart
///
/// Expects `locations.json` in the package root directory.

import 'dart:convert';
import 'dart:io';

// We import the same protobuf model the package uses at runtime.
import '../lib/src/models/location.pb.dart';

String _str(dynamic v) => (v as String?)?.trim() ?? '';

void main() {
  final jsonFile = File('locations.json');
  if (!jsonFile.existsSync()) {
    print('ERROR: locations.json not found in the current directory.');
    exit(1);
  }

  final jsonString = jsonFile.readAsStringSync();
  final Map<String, dynamic> jsonData = json.decode(jsonString);
  final List<dynamic> items = jsonData['items'];

  final locationList = LocationList();

  var skipped = 0;
  for (final item in items) {
    final en = item['en'] as Map<String, dynamic>?;
    final bn = item['bn'] as Map<String, dynamic>?;

    if (en == null || bn == null) {
      skipped++;
      continue;
    }

    locationList.items.add(
      Location(
        divisionEn: _str(en['division']),
        districtEn: _str(en['district']),
        thanaEn: _str(en['thana']),
        subofficeEn: _str(en['suboffice']),
        postcodeEn: _str(en['postcode']),
        divisionBn: _str(bn['division']),
        districtBn: _str(bn['district']),
        thanaBn: _str(bn['thana']),
        subofficeBn: _str(bn['suboffice']),
        postcodeBn: _str(bn['postcode']),
      ),
    );
  }

  if (skipped > 0) {
    print('⚠ Skipped $skipped items with null en/bn fields.');
  }

  final outputDir = Directory('assets');
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  final outputFile = File('assets/locations.pb');
  outputFile.writeAsBytesSync(locationList.writeToBuffer());

  print('✔ Converted ${locationList.items.length} locations');
  print('✔ Output: assets/locations.pb (${outputFile.lengthSync()} bytes)');
}
