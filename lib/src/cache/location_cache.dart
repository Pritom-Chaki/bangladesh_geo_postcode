import '../loader/location_loader.dart';
import '../models/language.dart';
import '../models/location.pb.dart';
import '../utils/postcode_normalizer.dart';

/// Singleton in-memory cache for all location data.
///
/// Call [load] once during app startup. All subsequent look-ups are O(1)
/// map reads — the protobuf file is never re-loaded.
class LocationCache {
  LocationCache._();

  static final LocationCache instance = LocationCache._();

  bool _loaded = false;

  late final List<Location> _items;

  // ── indexed maps ──────────────────────────────────────────────────────

  /// postcode (normalised, English digits) → list of locations
  late final Map<String, List<Location>> _postcodeIndex;

  /// division (EN, lower) → list of locations
  late final Map<String, List<Location>> _divisionEnIndex;

  /// division (BN) → list of locations
  late final Map<String, List<Location>> _divisionBnIndex;

  /// "division_en|district_en" (lower) → list of locations
  late final Map<String, List<Location>> _districtEnIndex;

  /// "division_bn|district_bn" → list of locations
  late final Map<String, List<Location>> _districtBnIndex;

  /// "division_en|district_en|thana_en" (lower) → list of locations
  late final Map<String, List<Location>> _thanaEnIndex;

  /// "division_bn|district_bn|thana_bn" → list of locations
  late final Map<String, List<Location>> _thanaBnIndex;

  // ── public API ────────────────────────────────────────────────────────

  /// Whether [load] has completed successfully.
  bool get isLoaded => _loaded;

  /// Loads the protobuf asset and builds all lookup indices.
  ///
  /// Safe to call multiple times — subsequent calls are no-ops.
  Future<void> load() async {
    if (_loaded) return;

    final locationList = await loadLocations();
    _items = List<Location>.unmodifiable(locationList.items);

    _postcodeIndex = {};
    _divisionEnIndex = {};
    _divisionBnIndex = {};
    _districtEnIndex = {};
    _districtBnIndex = {};
    _thanaEnIndex = {};
    _thanaBnIndex = {};

    for (final loc in _items) {
      // Postcode index (normalised English digits)
      final normCode = normalizePostcode(loc.postcodeEn);
      (_postcodeIndex[normCode] ??= []).add(loc);

      // Division indices
      final divEn = loc.divisionEn.toLowerCase();
      final divBn = loc.divisionBn;
      (_divisionEnIndex[divEn] ??= []).add(loc);
      (_divisionBnIndex[divBn] ??= []).add(loc);

      // District indices
      final distEnKey = '$divEn|${loc.districtEn.toLowerCase()}';
      final distBnKey = '$divBn|${loc.districtBn}';
      (_districtEnIndex[distEnKey] ??= []).add(loc);
      (_districtBnIndex[distBnKey] ??= []).add(loc);

      // Thana indices
      final thanaEnKey = '$distEnKey|${loc.thanaEn.toLowerCase()}';
      final thanaBnKey = '$distBnKey|${loc.thanaBn}';
      (_thanaEnIndex[thanaEnKey] ??= []).add(loc);
      (_thanaBnIndex[thanaBnKey] ??= []).add(loc);
    }

    _loaded = true;
  }

  /// Returns every loaded [Location].
  List<Location> getAll() {
    _assertLoaded();
    return _items;
  }

  // ── Division ──────────────────────────────────────────────────────────

  /// Unique division names in the requested [lang].
  List<String> getDivisions(Language lang) {
    _assertLoaded();
    switch (lang) {
      case Language.en:
        return _divisionEnIndex.keys
            .map((k) => _divisionEnIndex[k]!.first.divisionEn)
            .toList();
      case Language.bn:
        return _divisionBnIndex.keys.toList();
    }
  }

  // ── District ──────────────────────────────────────────────────────────

  /// Districts within a [division], in the requested [lang].
  List<String> getDistricts(String division, Language lang) {
    _assertLoaded();
    switch (lang) {
      case Language.en:
        final prefix = '${division.toLowerCase()}|';
        return _districtEnIndex.keys
            .where((k) => k.startsWith(prefix))
            .map((k) => _districtEnIndex[k]!.first.districtEn)
            .toList();
      case Language.bn:
        final prefix = '$division|';
        return _districtBnIndex.keys
            .where((k) => k.startsWith(prefix))
            .map((k) => _districtBnIndex[k]!.first.districtBn)
            .toList();
    }
  }

  // ── Thana ─────────────────────────────────────────────────────────────

  /// Thanas within a [division] + [district], in the requested [lang].
  List<String> getThanas(
    String division,
    String district,
    Language lang,
  ) {
    _assertLoaded();
    switch (lang) {
      case Language.en:
        final prefix =
            '${division.toLowerCase()}|${district.toLowerCase()}|';
        return _thanaEnIndex.keys
            .where((k) => k.startsWith(prefix))
            .map((k) => _thanaEnIndex[k]!.first.thanaEn)
            .toList();
      case Language.bn:
        final prefix = '$division|$district|';
        return _thanaBnIndex.keys
            .where((k) => k.startsWith(prefix))
            .map((k) => _thanaBnIndex[k]!.first.thanaBn)
            .toList();
    }
  }

  // ── Postcode search ───────────────────────────────────────────────────

  /// Finds the first location matching [postcode] (Bangla or English).
  ///
  /// Returns `null` when no match is found.
  Location? searchByPostcode(String postcode) {
    _assertLoaded();
    final key = normalizePostcode(postcode);
    final list = _postcodeIndex[key];
    return (list != null && list.isNotEmpty) ? list.first : null;
  }

  /// All locations matching [postcode] (Bangla or English).
  List<Location> searchAllByPostcode(String postcode) {
    _assertLoaded();
    final key = normalizePostcode(postcode);
    return _postcodeIndex[key] ?? const [];
  }

  // ── Bulk postcode lists ───────────────────────────────────────────────

  /// All locations belonging to [division].
  List<Location> getPostcodesByDivision(String division, {Language lang = Language.en}) {
    _assertLoaded();
    switch (lang) {
      case Language.en:
        return _divisionEnIndex[division.toLowerCase()] ?? const [];
      case Language.bn:
        return _divisionBnIndex[division] ?? const [];
    }
  }

  /// All locations belonging to [district] within [division].
  List<Location> getPostcodesByDistrict(
    String division,
    String district, {
    Language lang = Language.en,
  }) {
    _assertLoaded();
    switch (lang) {
      case Language.en:
        final key =
            '${division.toLowerCase()}|${district.toLowerCase()}';
        return _districtEnIndex[key] ?? const [];
      case Language.bn:
        final key = '$division|$district';
        return _districtBnIndex[key] ?? const [];
    }
  }

  /// All locations belonging to [thana] within [division] + [district].
  List<Location> getPostcodesByThana(
    String division,
    String district,
    String thana, {
    Language lang = Language.en,
  }) {
    _assertLoaded();
    switch (lang) {
      case Language.en:
        final key =
            '${division.toLowerCase()}|${district.toLowerCase()}|${thana.toLowerCase()}';
        return _thanaEnIndex[key] ?? const [];
      case Language.bn:
        final key = '$division|$district|$thana';
        return _thanaBnIndex[key] ?? const [];
    }
  }

  // ── internal ──────────────────────────────────────────────────────────

  void _assertLoaded() {
    if (!_loaded) {
      throw StateError(
        'LocationCache has not been loaded. '
        'Call `await LocationCache.instance.load()` before accessing data.',
      );
    }
  }
}
