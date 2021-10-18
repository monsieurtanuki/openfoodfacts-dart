import 'package:json_annotation/json_annotation.dart';
import '../interface/JsonObject.dart';

part 'OrderedNutrient.g.dart';

/// Nutrient, as a hierarchically ordered and localized entity.
///
/// cf. https://github.com/openfoodfacts/openfoodfacts-dart/issues/210
/// Example in https://fr.openfoodfacts.org/cgi/nutrients.pl
/// To be compared to [OrderedNutrients], which is the root of the structure.
@JsonSerializable(includeIfNull: false)
class OrderedNutrient extends JsonObject {
  /// Nutrient ID (e.g. 'energy-kcal')
  @JsonKey()
  final String id;

  /// Localized nutrient name (e.g. 'Energía (kcal)' in Spanish)
  @JsonKey()
  final String? name;

  @JsonKey()
  final bool important;

  @JsonKey(name: 'display_in_edit_form')
  final bool displayInEditForm;

  /// Hierarchically related nutrients
  @JsonKey(name: 'nutrients')
  final List<OrderedNutrient>? subNutrients;

  OrderedNutrient({
    required this.important,
    required this.id,
    required this.displayInEditForm,
    this.name,
    this.subNutrients,
  });

  factory OrderedNutrient.fromJson(Map<String, dynamic> json) =>
      _$OrderedNutrientFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OrderedNutrientToJson(this);
}
