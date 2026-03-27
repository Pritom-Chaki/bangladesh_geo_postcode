/// Offline Bangladesh geographic postcode lookup.
///
/// Supports Division → District → Thana → Postcode navigation in both
/// Bangla and English, powered by Protocol Buffers for fast loading.
library;

export 'src/cache/location_cache.dart';
export 'src/models/language.dart';
export 'src/models/location.pb.dart' show Location;
export 'src/services/location_service.dart';
export 'src/utils/postcode_normalizer.dart' show normalizePostcode;
