import 'package:json_annotation/json_annotation.dart';

import 'currency.dart';
import 'location.dart';
import 'location_osm_type.dart';
import 'proof_type.dart';
import '../interface/json_object.dart';
import '../open_prices_api_client.dart';
import '../utils/json_helper.dart';
import '../utils/uri_helper.dart';

part 'proof.g.dart';

/// Proof of a price.
///
/// cf. `ProofFull` in https://prices.openfoodfacts.org/api/docs
@JsonSerializable()
class Proof extends JsonObject {
  /// Proof ID. Read-only.
  @JsonKey()
  late int id;

  /// Image file path. Read-only.
  @JsonKey(name: 'file_path')
  String? filePath;

  /// Mime type. Read-only.
  @JsonKey()
  late String mimetype;

  /// Proof type.
  @JsonKey()
  ProofType? type;

  /// Number of prices for this proof. Read-only.
  @JsonKey(name: 'price_count')
  late int priceCount;

  /// ID of the location in OpenStreetMap.
  ///
  /// The store where the product was bought.
  @JsonKey(name: 'location_osm_id')
  int? locationOSMId;

  /// Type of the OpenStreetMap location object.
  ///
  /// Stores can be represented as nodes, ways or relations in OpenStreetMap.
  /// It is necessary to be able to fetch the correct information about the
  /// store using the ID.
  @JsonKey(name: 'location_osm_type')
  LocationOSMType? locationOSMType;

  /// Location ID.
  @JsonKey(name: 'location_id')
  int? locationId;

  /// Date when the product was bought.
  @JsonKey(fromJson: JsonHelper.nullableStringTimestampToDate)
  DateTime? date;

  /// Currency of the price.
  ///
  /// The currency must be a valid currency code.
  /// See https://en.wikipedia.org/wiki/ISO_4217 for a list of valid currency
  /// codes.
  @JsonKey()
  Currency? currency;

  /// Owner. Read-only.
  @JsonKey()
  late String owner;

  /// Creation timestamp. Read-only.
  @JsonKey(fromJson: JsonHelper.stringTimestampToDate)
  late DateTime created;

  /// Latest update timestamp. Read-only.
  @JsonKey(fromJson: JsonHelper.nullableStringTimestampToDate)
  DateTime? updated;

  /// Location. Read-only.
  @JsonKey()
  Location? location;

  Proof();

  factory Proof.fromJson(Map<String, dynamic> json) => _$ProofFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProofToJson(this);

  /// Returns the URL of the proof image.
  Uri? getFileUrl({required final UriProductHelper uriProductHelper}) =>
      filePath == null
          ? null
          : OpenPricesAPIClient.getUri(
              path: 'img/$filePath',
              uriHelper: uriProductHelper,
              addUserAgentParameters: false,
            );
}
