import 'package:bangladesh_geo_postcode/bangladesh_geo_postcode.dart';

Future<void> main() async {
  // 1. Load data once at app startup.
  await LocationCache.instance.load();

  // 2. Use the service for queries.
  const service = LocationService();

  // Get all divisions in English.
  final divisions = service.getDivisions(Language.en);
  print('Divisions (EN): $divisions');

  // Get all divisions in Bangla.
  final divisionsBn = service.getDivisions(Language.bn);
  print('Divisions (BN): $divisionsBn');

  // Get districts of Dhaka division.
  final districts = service.getDistricts('Dhaka', Language.en);
  print('Districts in Dhaka: $districts');

  // Get thanas in Dhaka district.
  final thanas = service.getThanas('Dhaka', 'Dhaka', Language.en);
  print('Thanas in Dhaka/Dhaka: $thanas');

  // Search by English postcode.
  final result = service.searchByPostcode('1206');
  if (result != null) {
    print('Postcode 1206 → ${result.thanaEn}, ${result.districtEn}');
  }

  // Search by Bangla postcode.
  final resultBn = service.searchByPostcode('১২০৬');
  if (resultBn != null) {
    print('পোস্টকোড ১২০৬ → ${resultBn.thanaBn}, ${resultBn.districtBn}');
  }

  // Get all postcodes in a division.
  final dhakaCodes = service.getPostcodesByDivision('Dhaka');
  print('Total postcodes in Dhaka division: ${dhakaCodes.length}');

  // Get all postcodes in a district.
  final distCodes = service.getPostcodesByDistrict('Dhaka', 'Dhaka');
  print('Total postcodes in Dhaka/Dhaka district: ${distCodes.length}');

  // Get all postcodes in a thana.
  final thanaCodes = service.getPostcodesByThana('Dhaka', 'Dhaka', 'Dhamrai');
  print('Postcodes in Dhamrai thana: ${thanaCodes.length}');
}
