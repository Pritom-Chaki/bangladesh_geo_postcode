import '../cache/location_cache.dart';
import '../models/language.dart';
import '../models/location.pb.dart';

/// High-level, stateless API that delegates to [LocationCache].
///
/// All methods assume [LocationCache.instance.load] has already been called.
class LocationService {
  const LocationService();

  // ── Divisions ─────────────────────────────────────────────────────────

  /// Returns all unique division names.
  List<String> getDivisions(Language lang) =>
      LocationCache.instance.getDivisions(lang);

  // ── Districts ─────────────────────────────────────────────────────────

  /// Districts within [division].
  List<String> getDistricts(String division, Language lang) =>
      LocationCache.instance.getDistricts(division, lang);

  // ── Thanas ────────────────────────────────────────────────────────────

  /// Thanas within [division] → [district].
  List<String> getThanas(
    String division,
    String district,
    Language lang,
  ) =>
      LocationCache.instance.getThanas(division, district, lang);

  // ── Postcode search ───────────────────────────────────────────────────

  /// First match for [postcode]. Accepts both Bangla and English digits.
  Location? searchByPostcode(String postcode) =>
      LocationCache.instance.searchByPostcode(postcode);

  /// All matches for [postcode].
  List<Location> searchAllByPostcode(String postcode) =>
      LocationCache.instance.searchAllByPostcode(postcode);

  // ── Bulk postcode lists ───────────────────────────────────────────────

  List<Location> getPostcodesByDivision(String division,
          {Language lang = Language.en}) =>
      LocationCache.instance.getPostcodesByDivision(division, lang: lang);

  List<Location> getPostcodesByDistrict(
    String division,
    String district, {
    Language lang = Language.en,
  }) =>
      LocationCache.instance
          .getPostcodesByDistrict(division, district, lang: lang);

  List<Location> getPostcodesByThana(
    String division,
    String district,
    String thana, {
    Language lang = Language.en,
  }) =>
      LocationCache.instance
          .getPostcodesByThana(division, district, thana, lang: lang);

  // ── All ───────────────────────────────────────────────────────────────

  List<Location> getAll() => LocationCache.instance.getAll();
}
