# bangladesh_geo_postcode

Offline Bangladesh geographic postcode lookup for Flutter. Supports **Division → District → Thana → Postcode** navigation in both **Bangla** and **English**.

Uses **Protocol Buffers** for fast binary loading — no database, no API, fully offline.

## Features

- Division / District / Thana / Postcode hierarchy
- Bangla & English language support
- O(1) postcode search (supports both `1206` and `১২০৬`)
- One-time protobuf load, in-memory cache
- No network, no SQLite, no external dependency

## Getting Started

### 1. Add dependency

```yaml
dependencies:
  bangladesh_geo_postcode: ^0.0.1
```

### 2. Generate the protobuf binary

Place your `locations.json` in the package root, then run:

```bash
dart run tool/convert_json_to_protobuf.dart
```

This creates `assets/locations.pb`.

### 3. Initialise at app startup

```dart
import 'package:bangladesh_geo_postcode/bangladesh_geo_postcode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocationCache.instance.load();
  runApp(MyApp());
}
```

## Usage

```dart
const service = LocationService();

// Divisions
final divisions = service.getDivisions(Language.en);
final divisionsBn = service.getDivisions(Language.bn);

// Districts in a division
final districts = service.getDistricts('Dhaka', Language.en);

// Thanas in a district
final thanas = service.getThanas('Dhaka', 'Dhaka', Language.en);

// Search by postcode (English or Bangla)
final result = service.searchByPostcode('1206');
final resultBn = service.searchByPostcode('১২০৬');

// Bulk postcodes
final byCodes = service.getPostcodesByDivision('Dhaka');
final distCodes = service.getPostcodesByDistrict('Dhaka', 'Dhaka');
final thanaCodes = service.getPostcodesByThana('Dhaka', 'Dhaka', 'Dhamrai');
```

## Architecture

```
locations.json
     │
     ▼  (dart run tool/convert_json_to_protobuf.dart)
assets/locations.pb
     │
     ▼  (rootBundle.load at runtime)
LocationCache (singleton, in-memory)
     │
     ▼
LocationService (stateless query API)
```

## API Reference

| Method | Returns |
|---|---|
| `getDivisions(Language)` | `List<String>` |
| `getDistricts(division, Language)` | `List<String>` |
| `getThanas(division, district, Language)` | `List<String>` |
| `searchByPostcode(postcode)` | `Location?` |
| `searchAllByPostcode(postcode)` | `List<Location>` |
| `getPostcodesByDivision(division)` | `List<Location>` |
| `getPostcodesByDistrict(division, district)` | `List<Location>` |
| `getPostcodesByThana(division, district, thana)` | `List<Location>` |

## License

MIT
