import 'package:flutter/services.dart' show rootBundle;

import '../models/location.pb.dart';

/// Loads the protobuf binary asset and returns a parsed [LocationList].
Future<LocationList> loadLocations() async {
  final data = await rootBundle.load('packages/bangladesh_geo_postcode/assets/locations.pb');
  return LocationList.fromBuffer(data.buffer.asUint8List());
}
