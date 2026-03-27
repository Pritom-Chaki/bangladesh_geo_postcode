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

  for (final item in items) {
    final en = item['en'] as Map<String, dynamic>;
    final bn = item['bn'] as Map<String, dynamic>;

    locationList.items.add(
      Location(
        divisionEn: en['division'] ?? '',
        districtEn: en['district'] ?? '',
        thanaEn: en['thana'] ?? '',
        subofficeEn: en['suboffice'] ?? '',
        postcodeEn: en['postcode'] ?? '',
        divisionBn: bn['division'] ?? '',
        districtBn: bn['district'] ?? '',
        thanaBn: bn['thana'] ?? '',
        subofficeBn: bn['suboffice'] ?? '',
        postcodeBn: bn['postcode'] ?? '',
      ),
    );
  }

  final outputDir = Directory('assets');
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  final outputFile = File('assets/locations.pb');
  outputFile.writeAsBytesSync(locationList.writeToBuffer());

  print('✔ Converted ${items.length} locations');
  print('✔ Output: assets/locations.pb (${outputFile.lengthSync()} bytes)');
}
