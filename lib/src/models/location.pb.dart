// Generated-like protobuf model for Location and LocationList.
// This file mirrors what `protoc` would generate but is hand-written
// so the package has zero native build dependency on the protoc compiler.

import 'package:protobuf/protobuf.dart' as $pb;

class Location extends $pb.GeneratedMessage {
  factory Location({
    String? divisionEn,
    String? districtEn,
    String? thanaEn,
    String? subofficeEn,
    String? postcodeEn,
    String? divisionBn,
    String? districtBn,
    String? thanaBn,
    String? subofficeBn,
    String? postcodeBn,
  }) {
    final result = Location._();
    if (divisionEn != null) result.divisionEn = divisionEn;
    if (districtEn != null) result.districtEn = districtEn;
    if (thanaEn != null) result.thanaEn = thanaEn;
    if (subofficeEn != null) result.subofficeEn = subofficeEn;
    if (postcodeEn != null) result.postcodeEn = postcodeEn;
    if (divisionBn != null) result.divisionBn = divisionBn;
    if (districtBn != null) result.districtBn = districtBn;
    if (thanaBn != null) result.thanaBn = thanaBn;
    if (subofficeBn != null) result.subofficeBn = subofficeBn;
    if (postcodeBn != null) result.postcodeBn = postcodeBn;
    return result;
  }

  Location._() : super();

  factory Location.fromBuffer(List<int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);

  factory Location.fromJson(String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    'Location',
    createEmptyInstance: create,
  )
    ..aOS(1, 'divisionEn')
    ..aOS(2, 'districtEn')
    ..aOS(3, 'thanaEn')
    ..aOS(4, 'subofficeEn')
    ..aOS(5, 'postcodeEn')
    ..aOS(6, 'divisionBn')
    ..aOS(7, 'districtBn')
    ..aOS(8, 'thanaBn')
    ..aOS(9, 'subofficeBn')
    ..aOS(10, 'postcodeBn')
    ..hasRequiredFields = false;

  @override
  $pb.BuilderInfo get info_ => _i;

  static Location create() => Location._();

  @override
  Location createEmptyInstance() => create();

  @override
  Location clone() => Location()..mergeFromMessage(this);

  // Field 1 — division_en
  String get divisionEn => $_getSZ(0);
  set divisionEn(String value) => $_setString(0, value);
  bool hasDivisionEn() => $_has(0);
  void clearDivisionEn() => clearField(1);

  // Field 2 — district_en
  String get districtEn => $_getSZ(1);
  set districtEn(String value) => $_setString(1, value);
  bool hasDistrictEn() => $_has(1);
  void clearDistrictEn() => clearField(2);

  // Field 3 — thana_en
  String get thanaEn => $_getSZ(2);
  set thanaEn(String value) => $_setString(2, value);
  bool hasThanaEn() => $_has(2);
  void clearThanaEn() => clearField(3);

  // Field 4 — suboffice_en
  String get subofficeEn => $_getSZ(3);
  set subofficeEn(String value) => $_setString(3, value);
  bool hasSubofficeEn() => $_has(3);
  void clearSubofficeEn() => clearField(4);

  // Field 5 — postcode_en
  String get postcodeEn => $_getSZ(4);
  set postcodeEn(String value) => $_setString(4, value);
  bool hasPostcodeEn() => $_has(4);
  void clearPostcodeEn() => clearField(5);

  // Field 6 — division_bn
  String get divisionBn => $_getSZ(5);
  set divisionBn(String value) => $_setString(5, value);
  bool hasDivisionBn() => $_has(5);
  void clearDivisionBn() => clearField(6);

  // Field 7 — district_bn
  String get districtBn => $_getSZ(6);
  set districtBn(String value) => $_setString(6, value);
  bool hasDistrictBn() => $_has(6);
  void clearDistrictBn() => clearField(7);

  // Field 8 — thana_bn
  String get thanaBn => $_getSZ(7);
  set thanaBn(String value) => $_setString(7, value);
  bool hasThanaBn() => $_has(7);
  void clearThanaBn() => clearField(8);

  // Field 9 — suboffice_bn
  String get subofficeBn => $_getSZ(8);
  set subofficeBn(String value) => $_setString(8, value);
  bool hasSubofficeBn() => $_has(8);
  void clearSubofficeBn() => clearField(9);

  // Field 10 — postcode_bn
  String get postcodeBn => $_getSZ(9);
  set postcodeBn(String value) => $_setString(9, value);
  bool hasPostcodeBn() => $_has(9);
  void clearPostcodeBn() => clearField(10);
}

class LocationList extends $pb.GeneratedMessage {
  factory LocationList({Iterable<Location>? items}) {
    final result = LocationList._();
    if (items != null) result.items.addAll(items);
    return result;
  }

  LocationList._() : super();

  factory LocationList.fromBuffer(List<int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    'LocationList',
    createEmptyInstance: create,
  )
    ..pc<Location>(1, 'items', $pb.PbFieldType.PM,
        subBuilder: Location.create)
    ..hasRequiredFields = false;

  @override
  $pb.BuilderInfo get info_ => _i;

  static LocationList create() => LocationList._();

  @override
  LocationList createEmptyInstance() => create();

  @override
  LocationList clone() => LocationList()..mergeFromMessage(this);

  List<Location> get items => $_getList<Location>(0);
}
