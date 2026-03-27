# bangladesh_geo_postcode

Offline Bangladesh geographic postcode lookup for Flutter. Supports **Division > District > Thana > Postcode** navigation in both **Bangla** and **English**.

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

### 2. Initialise at app startup

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

// Get all divisions
final divisions = service.getDivisions(Language.en);
final divisionsBn = service.getDivisions(Language.bn);

// Get districts in a division
final districts = service.getDistricts('Dhaka', Language.en);

// Get thanas in a district
final thanas = service.getThanas('Dhaka', 'Dhaka', Language.en);

// Search by postcode (English or Bangla)
final result = service.searchByPostcode('1206');
final resultBn = service.searchByPostcode('১২০৬');

// Access location fields
if (result != null) {
  print(result.divisionEn);   // Dhaka
  print(result.districtBn);   // ঢাকা
  print(result.thanaEn);      // Dhaka
  print(result.postcodeEn);   // 1206
  print(result.postcodeBn);   // ১২০৬
  print(result.subofficeEn);  // Dhaka Cantonment--TSO
}

// Get all postcodes in a division
final divCodes = service.getPostcodesByDivision('Dhaka');

// Get all postcodes in a district
final distCodes = service.getPostcodesByDistrict('Dhaka', 'Dhaka');

// Get all postcodes in a thana
final thanaCodes = service.getPostcodesByThana('Dhaka', 'Dhaka', 'Dhamrai');
```

## Bangla Postcode Search

The postcode normalizer automatically converts Bangla digits to English for matching:

```dart
// Both return the same result
service.searchByPostcode('1206');
service.searchByPostcode('১২০৬');
```

You can also use the normalizer directly:

```dart
final normalized = normalizePostcode('১২০৬'); // "1206"
```

## API Reference

### LocationCache

| Method | Description |
|---|---|
| `LocationCache.instance.load()` | Load data into memory (call once at startup) |
| `LocationCache.instance.isLoaded` | Whether data has been loaded |

### LocationService

| Method | Returns | Description |
|---|---|---|
| `getDivisions(Language)` | `List<String>` | All unique division names |
| `getDistricts(division, Language)` | `List<String>` | Districts within a division |
| `getThanas(division, district, Language)` | `List<String>` | Thanas within a district |
| `searchByPostcode(postcode)` | `Location?` | First match for a postcode |
| `searchAllByPostcode(postcode)` | `List<Location>` | All matches for a postcode |
| `getPostcodesByDivision(division)` | `List<Location>` | All locations in a division |
| `getPostcodesByDistrict(division, district)` | `List<Location>` | All locations in a district |
| `getPostcodesByThana(division, district, thana)` | `List<Location>` | All locations in a thana |
| `getAll()` | `List<Location>` | Every loaded location |

### Location Fields

| Field | Type | Description |
|---|---|---|
| `divisionEn` / `divisionBn` | `String` | Division name |
| `districtEn` / `districtBn` | `String` | District name |
| `thanaEn` / `thanaBn` | `String` | Thana name |
| `subofficeEn` / `subofficeBn` | `String` | Sub-office name |
| `postcodeEn` / `postcodeBn` | `String` | Postcode |

### Language

```dart
enum Language { en, bn }
```

## License

MIT
